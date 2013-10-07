#ifndef CloudCode
request = require 'request'
#endif
_ = require 'underscore'
{Cookie, CookieJar} = require './cookie'
{entrances, cities} = require './metadata'
{queryOwners, scheduleCount, queryDateCount} = require './shared/queries'

user_agent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_4) AppleWebKit/536.30.1 (KHTML, like Gecko) Version/6.0.5 Safari/536.30.1"

class Task
  
  constructor: (@owner, cb) ->
    @jar = new CookieJar
    @entrance = @prepare()
    
    _setupOptions = (options) =>
      options.headers ?= {}
      _.extend options.headers,
        'User-Agent': user_agent
        'Cookie': @jar.cookieString()
    
    _saveCookie = (res) =>
      cookies = res.headers['Set-Cookie']
      if cookies
        if typeof cookies isnt 'object'
          cookies = [cookies]
        cookies.forEach (cookie) =>
          @jar.add new Cookie cookie
        console.log "cookies: #{cookies}"
    
    if request?
      @request = (options, callback) =>
        _setupOptions(options)
        
        request options, (error, res, body) ->
          if not error
            _saveCookie(res)
          callback?(error, res, body)
        
    else
      @request = (options, callback) =>
        if options.form
          options.body = form
          delete options.form
        _setupOptions(options)
        
        _.extend options,
          success: (res) =>
            _saveCookie(res)
            callback?(null, res, res.data)
          error: (res) =>
            callback?(code: res.status, res)
        Parse.Cloud.httpRequest options
    
    @emulate(cb) if cb
  
  city: ->
    area = @owner.get('area')
    for city, codes of cities
      if area is city or area.search(city) >= 0 or city.search(area) >= 0
        return codes
    if not found
      throw new Error "not found area: #{area}"
  
  toJSON: ->
    cookies: @jar.cookies.map (cookie) -> cookie.toString()
    form: @form
  
  emulate: (cb) ->
  prepare: ->

class QQ extends Task
  
  skey: "@yu0m1qD8w"
  
  prepare: ->
    citycodes = @city()
    @form =
      city: citycodes[1]
      carnum: @owner.get('car_number')
      name: @owner.get('name')
      mobile: @owner.get('mobile')
      province: citycodes[0]
      buytime: "#{@owner.get('first_year')}-#{@owner.get('first_month')}"
    
    currentCookie = "641010351_check_login_production=2762912560; 641010351_check_register_production=2762912560; pt2gguin=o2762912560; ptcz=5ece04ca0c4aa9b9992d5ff10d464873a9221be0b0a7d3cc0d87474cf060e280; ptisp=ctc; ptui_loginuin=2762912560; uin=o2762912560; RK=QZKW+m37Mo"
    cookies = currentCookie.split(";").map (s) -> new Cookie(s)
    @jar = new CookieJar cookies
    @jar.add new Cookie "skey=#{@skey}"
  
  getToken: ->
    skey = @jar.get("skey").value or ""
    hash = 5381
    for i in [0...skey.length]
      hash += (hash << 5 & 0x7fffffff) + skey[i].charCodeAt()
    hash & 0x7fffffff
  
  emulate: (cb) ->
    @form.g_tk = @getToken()
    @request
      url: "http://chinadrivers.act.qq.com/act/saveuserinfo"
      method: 'POST'
      form: @form
    , (error, res, body) ->
      body = JSON.parse(body)
      if body.code is 0
        cb?(body.exchangeCode, 'qq', error)
      else
        cb?(null, null, body)

exports.QQ = QQ


class Ecpic extends Task

  @step1_url: 'http://www.ecpic.com.cn/cpicmall/sales/vehicle/cpicFastCalculation-submitBusinessOpportunity.do'
  @step2_url: 'http://www.ecpic.com.cn/cpicmall/sales/vehicle/cpicFastCalculation-fastCalculation.do'
  
  prepare: ->
    entrance = entrances[Math.floor(Math.random() * entrances.length)]
    pid = entrance.match(/cmpid=([^&]+)/)[1]
    form =
      method: 'submitBusinessOpportunity'
      isCpic: 0
      isNewCar: 0
      licenseNo: @owner.get('car_number')
      mobilePhone: @owner.get('mobile')
      email: ''
      source: '163'
      bSource: 'null'
      sourceName: ''
      cmPid: pid
    
    codes = @city()
    form.provinceCode = codes[0]
    form.cityCode = codes[1]
    @form = form
    entrance
  
  emulate: (cb) ->
    @step0 (err0) =>
      return cb?(null, @form.cmPid, err0) if err0
      setTimeout =>
        @step1 (taskId, err1) =>
          if taskId
            setTimeout @step2.bind(@), 1000
          cb?(taskId, @form.cmPid, err1)
      , 5000
  
  step0: (callback) ->
    @request
      url: @entrance
      method: 'GET'
    , (error, res, body) ->
      callback?(error)
  
  step1: (callback) ->
    @request
      url: Ecpic.step1_url
      method: 'POST'
      form: @form
      headers:
        'Referer': @entrance
    , (error, res, body) =>
      if body
        @prepare2(body)
      callback?(body, error)
  
  step2: (callback) ->
    @request
      url: Ecpic.step2_url
      method: 'POST'
      form: @form
      headers:
        'Referer': Ecpic.step1_url
    , (error, res, body) ->
      callback?(error)
  
  prepare2: (taskId) ->
    @form.taskId = taskId
    delete @form.method
    @form.vehiclePrice = @owner.get('price')
    @form.seatCount = 5
    @form.p09Flag = 'n'
    @form.ilogFlag = 'null'
    @form.viewFlag = 'null'
    @form.mail = ''
    @form.claim = '1'
    year = @owner.get('first_year')
    month = @owner.get('first_month')
    day = @owner.get('first_day')
    if month < 10
      month = '0' + month
    if day < 10
      day = '0' + day
    @form.registerDate = "#{year}-#{month}-#{day}"
    @form.contractExpiredMonth = "#{year + 1}-#{month}-#{day}"


exports.Ecpic = Ecpic


exports.speed = (cb) ->
  queryDateCount new Date(), (q, used) =>
    now = new Date()
    count = scheduleCount(now)
    if count > used
      mins = (now.getUTCHours() + 8) * 60 + now.getMinutes()
      return if mins < 8 * 60
      timeLeft = 18 * 60 - mins
      _speed = (count - used) / timeLeft
      speed = Math.min(Math.max(_speed, 1), 10)
      cb?(speed)

exports.startARandomTask = (cb) ->
  query = queryOwners()
  query.first
    success: (owner) ->
      new Ecpic owner, (taskId, pid, error) ->
        if error
          console.log error
          return cb?(500, error:error)
        if taskId.length < 20
          owner.set('used', new Date())
          owner.set('track', taskId)
          owner.set('nimpid', pid)
          owner.save(null, 
            success: ->
              console.log "saved #{owner.get('car_number')}: #{pid} -> #{taskId}"
            error: (object, error) ->
              console.log "error #{error}"
          )
          return cb?(200, car_number: owner.get('car_number'), pid: pid, taskId: taskId)
        else
          console.log "can't save #{owner.get('car_number')}: #{pid}"
          owner.set('track', 'error: track to large')
          owner.save(null)
          cb?(200, car_number: owner.get('car_number'), pid: pid, error: 'track to large')
    error: (owner, error) ->
      cb?(500, error: error)