express = require 'express'
log = require './log'

Scheduler = require './scheduler'
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
#endif

scheduler = null
scheduler2 = null

app.get '/scheduler', (req, res) ->
  json =
    speed: scheduler.speed
    count: scheduler.count
  res.json 200, json

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

#ifndef CloudCode
port = process.env.PORT or 3000
server.listen port, ->
  log.debug "Listening on #{port}"
  scheduler = new Scheduler
    task: require './taiping'
    end_hour: 22
    speed_factor: 1
    scheduleCount: -> 300
    queryDateCount: (date, callback) ->
      queries.queryDateCount 'CarOwner2', date, null, callback

#endifapp.listen()
