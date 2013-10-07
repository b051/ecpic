express = require 'express'
if process?.env?.LOGENTRIES_TOKEN
  log = require('node-logentries').logger
    token:process.env.LOGENTRIES_TOKEN
  console.log "logged to logentries"
else
  log =
    debug: console.log
    err: console.error
    info: console.info
    log: console.log

{Ecpic, QQ} = require './form'
{Cookie, CookieJar} = require './cookie'
queries = require './shared/queries'

app = express()
app.use express.bodyParser()
app.use app.router

#ifndef CloudCode
server = require('http').createServer(app)
{Parse} = require('./shared/parse')
app.use express.static "#{__dirname}/../public"
#this is for debug coffeescript in chrome
app.use "/views", express.static "#{__dirname}/views"
app.use "/shared", express.static "#{__dirname}/shared"
app.use "/parse", express.static "#{__dirname}/../node_modules/parse/build"

login = (cb)->
  Parse.User.logIn 'sundaheng731@gmail.com', 'abcdef',
    success: ->
      cb?()

#endif
scheduler = null
scheduler2 = null

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
      console.log "start login..."
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

app.get '/scheduler', (req, res) ->
  json =
    speed: scheduler.speed
    count: scheduler.count
  res.json 200, json

app.post '/resetTrack', (req, res) ->
  reset = ->
    new Parse.Query("CarOwner").startsWith('track', 'tracked by').find
      success: (results) ->
        results.forEach (result) ->
          result.unset('track')
          result.save(null)
        res.json(200, count: results.length)
      error: (error) ->
        res.json 500, error: error
  
  if not Parse.User.current()
    return login =>
      reset()
  else
    reset()

app.post '/reset', (req, res) ->
  scheduler.reset()
  res.end()

app.post '/startPicking', (req, res) ->
  scheduler.ignoreReset = yes
  scheduler.startPicking(1)
  res.end()

app.post '/pick', (req, res) ->
  user = new Parse.Object._create('User')
  if req.body
    user.id = req.body.id
    user._sessionToken = req.body._sessionToken
  log.log "picking..."
  Parse.User._currentUser = user
  scheduler._pick (error, data) ->
    if error
      res.json 500, error: error
    else
      res.json 200, data

app.get '/use/:owner', (req, res) ->
  query = new Parse.Query('CarOwner')
  ownerId = req.params.owner
  # Parse.Cloud.useMasterKey?()
  log.log "checking #{ownerId}..."
  query.get ownerId,
    success: (owner) ->
      tracked = owner.get('track')
      if tracked
        return res.json 200, error:'duplicated'
      
      log.log "filling #{owner.get('name')}"
      scheduler.emulate owner, (error, data) ->
        if error
          log.error error
          res.json 500, error: error
        else
          res.json 200, data
      
    error: (object, error) ->
      #ifndef CloudCode
      if error.code is 119
        return login ->
          res.redirect req.url
      #endif
      res.json(500, error)

app.get '/export/:date', (req, res) ->
  date = req.params.date
  return res.json(500, error: 'require date path params') if not date
  Parse.Cloud.run 'export', date: date,
    success: (json) ->
      if res.attachment
        res.attachment("#{date}.csv")
      res.send(json.map((arr) -> "#{arr[0]},#{arr[1]},#{arr[2]},#{arr[3].toJSON()}").join('\n'))
    error: (error) ->
      res.json(500, error: error)

#ifndef CloudCode
port = process.env.PORT or 3000
server.listen port, ->
  console.log "Listening on #{port}"
  # scheduler2 = new Scheduler
  #   task: QQ
  #   queryDateCount: queries.queryQQDateCount
  #   scheduleCount: -> 1020
  
  scheduler = new Scheduler
    task: Ecpic
    scheduleCount: queries.scheduleCount
    queryDateCount: queries.queryDateCount
#endifapp.listen()
