{Parse} = require './coffee/shared/parse'
{print} = require 'sys'
fs = require 'fs'

upload = (file) ->
  fs.readFile file, (err, content) ->
    content = content.toString()
    lines = content.split '\r\n'
    CarOwner = Parse.Object.extend("CarOwner2")
    columns = lines.shift().split(',')
    keys = ['car_number', 'name', 'mobile', 'city', 'province', 'price', 'first_year', 'first_month', 'first_day']
    cols = {}
    for key in keys
      cols[key] = columns.indexOf(key)
    
    objects = []
    for line, i in lines
      values = line.split ','
      year = Number(values[cols['first_year']])
      month = Number(values[cols['first_month']])
      day = Number(values[cols['first_day']])
      
      object =
        car_number: values[cols['car_number']]
        name: values[cols['name']]
        mobile: values[cols['mobile']]
        city: values[cols['city']]
        province: values[cols['province']]
        price: Number(values[cols['price']])
        first_month: month
        first_day: day
        first_year: year
        first_date: new Date(year, month - 1, day)
      objects.push object
    
    pop = ->
      object = objects.pop()
      return if not object
      query = new Parse.Query(CarOwner)
      query.equalTo 'car_number', object.car_number
      query.first
        success: (obj) ->
          if obj
            pop()
            return
          owner = new CarOwner()
          index = i
          owner.save object,
            success: (obj) ->
              console.log obj.id
              pop()
        
            error: (object, error) ->
              console.log error, object
              console.log "error on line #{index} #{error}"
              pop()
    
    threads = 10
    for i in [0...threads]
      pop()

upload("ecpic2.csv")