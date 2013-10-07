class CookieJar

  constructor: (@cookies=[]) ->
  
  add: (cookie) ->
    @cookies = @cookies.filter (c) ->
      # Avoid duplication (same path, same name)
      not (c.name is cookie.name)
    @cookies.push cookie
  
  get: (name) ->
    now = new Date
    @cookies.filter (cookie) ->
      if now < cookie.expires
        if name?
          return cookie.name is name
        return yes
  
  cookieString: ->
    cookies = @get()
    if cookies.length
      cookies.map (cookie) ->
        cookie.name + "=" + cookie.value
      .join "; "

class Cookie
  constructor: (@str) ->
    @str.split(/\s*;\s*/).reduce ((obj, pair) ->
      p = pair.indexOf("=")
      key = (if p > 0 then pair.substring(0, p).trim() else pair.trim())
      lowerCasedKey = key.toLowerCase()
      value = (if p > 0 then pair.substring(p + 1).trim() else true)
      unless obj.name
      
        # First key is the name
        obj.name = key
        obj.value = value
      else if lowerCasedKey is "httponly"
        obj.httpOnly = value
      else
        obj[lowerCasedKey] = value
      obj
    ), @
  
    # Expires
    @expires = (if @expires then new Date(@expires) else Infinity)
  
  toString: ->
    @str

exports.CookieJar = CookieJar
exports.Cookie = Cookie