#ifndef CloudCode
request = require 'request'
{Cookie, CookieJar} = require './cookie'
iconv = require 'iconv-lite'
#endif
_ = require 'underscore'
{cities} = require './metadata'
{queryOwners, scheduleCount, queryDateCount} = require './shared/queries'

user_agent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_4) AppleWebKit/536.30.1 (KHTML, like Gecko) Version/6.0.5 Safari/536.30.1"

class Task
  
  encoding: 'utf-8'
  debug: no
  
  constructor: (@owner, cb) ->
    @jar = new CookieJar
    @entrance = @prepare?()
    
    _setupOptions = (options) =>
      options.encoding = null
      if @debug
        options.proxy = "http://10.0.1.8:8888"
      options.headers ?= {}
      options.headers['User-Agent'] = user_agent
      cookie = @jar.cookieString()
      if cookie
        options.headers['Cookie'] = cookie
    
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
        if typeof options isnt 'object'
          options = url: options
        _setupOptions(options)
        
        request options, (error, res, body) =>
          if not error
            _saveCookie(res)
          
          console.log @encoding
          callback? error, res, iconv.decode(body, @encoding)
    
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
    
    @emulate?(cb) if cb
  
  citycodes: ->
    area = @owner.get('area')
    for city, codes of cities
      if area is city or area.search(city) >= 0 or city.search(area) >= 0
        return codes
    if not found
      throw new Error "not found area: #{area}"
  
  toJSON: ->
    cookies: @jar.cookies.map (cookie) -> cookie.toString()
    form: @form

module.exports = Task