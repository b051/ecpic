{Parse} = require('./shared/parse')
log = require './log'

login = (cb)->
  Parse.User.logIn 'sundaheng731@gmail.com', 'abcdef',
    success: ->
      cb?()

class Scheduler
  
  constructor: (@config) ->
    config = 
      start_hour: 8
      end_hour: 18
      speed_factor: Math.E
      max_speed: 10
      min_speed: 1
      reset_every_n_pick: 50
    
    if not @config.start_hour
      @config.start_hour = config.start_hour
    if not @config.end_hour
      @config.end_hour= config.end_hour
    if not @config.speed_factor
      @config.speed_factor = config.speed_factor
    if not @config.max_speed
      @config.max_speed = config.max_speed
    if not @config.min_speed
      @config.min_speed = config.min_speed
    if not @config.reset_every_n_pick
      @config.reset_every_n_pick = config.reset_every_n_pick
    
    @reset()

  emulate: (owner, cb) ->
    try
      task = new @config.task owner
    catch error
      owner.save track: "error: #{error.message}"
      return cb? error.message,
        car: owner.get('car_number')
    
    task.emulate (result, pid, error) ->
      return cb? error if error
      if result.length < 20
        owner.save
          used: new Date
          track: result
          nimpid: pid
        ,
          success: ->
            cb? null,
              car: owner.get('car_number')
              pid: pid
              task: result
          error: (object, error) ->
            cb? error
      else
        log.err "can't save #{owner.get('car_number')}: #{pid}"
        owner.save track: 'error: wrong taskId'
        cb? 'wrong taskId',
          car: owner.get('car_number')
          pid: pid
  
  reset: ->
    if not Parse.User.current()
      log.log "start login..."
      return login =>
        @reset()
    return if @resetting
    
    @resetting = yes
    @ignoreReset = no
    clearInterval @timeout
    @count =
      scheduled: -1
      used: -1
      used_real: -1
    
    log.info 'resetting...'
    
    notify = =>
      if @count.scheduled >= 0 and @count.used_real >= 0
        if @count.scheduled > @count.used_real
          @catchUp()
        else
          @next()
        @resetting = no
    
    @count.scheduled = @config.scheduleCount(new Date())
    notify()
    
    @config.queryDateCount new Date(), (q, count) =>
      @count.used_real = @count.used = count
      notify()
    @
  
  next: ->
    clearInterval @clock
    @speed = -1
    now = new Date()
    date = now.getUTCDate()
    if now.getUTCHours() >= 16
      date += 1
    tomorrow = new Date(Date.UTC(now.getUTCFullYear(), now.getUTCMonth(), date + 1, @config.start_hour - 8))
    resetAfter = tomorrow.getTime() - now.getTime()
    clearTimeout @timeout
    @timeout = setTimeout =>
      @reset()
    , resetAfter
    log.info "today's job is done (#{@count.used_real}/#{@count.scheduled}). schedule next start in #{Math.floor(resetAfter / 3600000)}h#{Math.floor((resetAfter % 3600000) / 60000)}m"
  
  catchUp: ->
    now = new Date()
    mins = ((now.getUTCHours() + 8) % 24) * 60 + now.getMinutes()
    remain = @count.scheduled - @count.used
    if mins < @config.start_hour * 60
      if remain > 0
        speed = @config.max_speed
        @ignoreReset = yes
      else
        return @next()
    else
      @ignoreReset = no
      timeLeft = @config.end_hour * 60 - mins
      _speed = remain / timeLeft
      if _speed < 0
        _speed = @config.max_speed / @config.speed_factor
      speed = Math.max(_speed * @config.speed_factor, @config.min_speed)
    if @speed isnt speed
      @speed = speed
      log.info "adjust speed to #{@speed} per min, #{remain}/#{@count.scheduled} remaining for today"
      @startPicking()
  
  startPicking: (speed) ->
    clearInterval @clock
    @clock = setInterval @pick.bind(@), 60000 / (speed or @speed)
  
  _pick: (cb) ->
    Parse.Cloud.run 'pick', null, 
      success: (owner) =>
        @emulate owner, (error, data) ->
          log.err error if error
          log.info data if data
          cb?(error, data)
      
      error: (error) ->
        log.err error if error
        cb?(error)
  
  pick: ->
    if not Parse.User.current()
      return login =>
        @pick()
    @_pick (error, data) =>
      if not error
        @count.used += 1
        return if @ignoreReset is yes
        if @count.used - @count.used_real > @config.reset_every_n_pick or @count.used >= @count.scheduled
          @reset()

module.exports = Scheduler