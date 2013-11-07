App.HomeView = Parse.View.extend
  className: 'table-wrapper'
  template: $.template 'content-home'
  all_fields:
    car_number: "车牌"
    name: "姓名"
    mobile: "手机"
    first_year: "登记时间"
    first_month: ''
    first_day: ''
    used: "状态"
  
  initialize: ->
    
  events:
    'click .icon-cog': 'execute'
  
  _render: ->
    @$el.html @template all_fields: @all_fields, collection: @collection
    @table = @$('table.table').dataTable
      bAutoWidth: no
      aoColumnDefs:[
        aTargets: [0, 5, 6]
        bVisible: no
      ,
        aTargets: [4]
        mRender: (data, type, row) ->
          "#{data}/#{row[5]}/#{row[6]}"
      ,
        aTargets: [7]
        mRender: (data, type, row) ->
          if not data
            return '<ul class="actions" data-object-id="' + row[0] + '">
              <li><i class="icon-pencil icon-large"></i></li>
              <li><i class="icon-cog icon-large"></i></li>
              <li><i class="icon-remove icon-large"></i></li>
            </ul>'
          else if data is 'using'
            'using...'
          else
            "used on #{data.getFullYear()}/#{data.getMonth() + 1}/#{data.getDate()}"
      ]
  
  use: (owner, error) ->
    $.get "use/#{owner.id}", (data) =>
      @collection.remove owner
      if @collection.models.length < 50
        @collection.fetch()
      if error and data.error
        error?(data.error)
  
  execute: (event) ->
    objectId = $(event.currentTarget).parents('ul.actions').attr('data-object-id')
    owner = @collection.get(objectId)
    console.log "sending #{owner.id}"
    @use owner
  
  old_pick: ->
    owner = @collection.at(Math.floor(Math.random() * @collection.models.length))
    console.log "sending #{owner.id}"
    @use owner, (error) =>
      if error is 'duplicated'
        @old_pick()
  
  pick: ->
    user = Parse.User.current()
    data = id: user.id, _sessionToken: user._sessionToken
    $.post 'pick', data
  
  render: ->
    # @stats.on('countUpdate', @resetTimeClock.bind @)
    @collection = queryOwners("CarOwner").collection()
    @collection.on('all', @_render.bind @)
    @$el.html '<h4>Loading...</h4>'
    @collection.fetch
      success: @_render.bind @
    @
  
  resetTimeClock: (count) ->
    if count.scheduled >= count.used > 0
      now = new Date()
      mins = now.getHours() * 60 + now.getMinutes()
      return if mins < 8 * 60
      timeLeft = 18 * 60 - mins
      _speed = (count.scheduled - count.used) / timeLeft
      if _speed < 0
        _speed = 5
      speed = Math.ceil(Math.max(_speed * 2, 1))
      if @speed isnt speed
        @speed = speed
        console.log "adjust speed to #{@speed}(#{_speed}) per min"
        clearInterval App.clock
        App.clock = setInterval @pick.bind(@), 60000 / @speed
    else
      clearInterval App.clock
      console.log "today's job is done #{count.used}/#{count.scheduled}"
      clearInterval App.fetchInteval
      now = new Date()
      tomorrow = new Date(now.getFullYear(), now.getMonth(), now.getDate() + 1)
      resetAfter = tomorrow.getTime() - now.getTime()
      setTimeout =>
        @stats.reset()
      , resetAfter
      console.log "recheck stats after #{resetAfter}"
  
  saveCurrentUserToRoleName: (name) ->
    query = new Parse.Query(Parse.Role)
    query.equalTo 'name', name
    query.first
      success: (role) ->
        role.getUsers().add(Parse.User.current())
        role.save()

App.StatsView = Parse.View.extend
  className: 'row-fluid stats-row'
  template: $.template 'content-stats'
  
  fetchStats: ->
    notify = =>
      if @count.used and @count.scheduled
        @trigger 'countUpdate', @count
      @render()
    
    @count.scheduled = scheduleCount(new Date())
    notify()
    
    queryDateCount new Date(), (q, count) =>
      @count.used = count
      notify()
    
    new Parse.Query("User").count().then (count) =>
      @count.users = count
      notify()
    
    new Parse.Query("CarOwner").startsWith('track', 'error:').count().then (count) =>
      @count.failed = count
      notify()
    
  
  events:
    'click .stat .data': 'export'
  
  removeTracked: ->
    new Parse.Query("CarOwner").startsWith('track', 'tracked by').find
      success: (results) ->
        results.forEach (result) ->
          result.unset('track')
          result.save(null)
  
  export: ->
    
    console.log 'exporting...'
    queryDateCount new Date(), (query, count) =>
      console.log "count: #{count}"
      pages = Math.ceil(count / 100)
      console.log pages
      for i in [0...pages]
        query.skip i * 100
        query.find
          success: (results) ->
            _.each results, (result) ->
              console.log "#{result.get('car_number')}, #{result.get('nimpid')}, #{result.get('track')}, #{result.get('used')}"

  reset: ->
    @count = 
      used: 0
      users: 0
      failed: 0
    clearInterval App.fetchInteval
    App.fetchInteval = setInterval @fetchStats.bind(@), 60000
    @fetchStats()
    @render()
  
  initialize: ->
    @reset()
  
  render: ->
    @$el.html @template count:@count, today: new Date()