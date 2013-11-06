Task = require './task'

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

module.exports = QQ