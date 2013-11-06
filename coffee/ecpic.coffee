Task = require './task'
{entrances} = require './metadata'

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
    
    codes = @citycodes()
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


module.exports = Ecpic
