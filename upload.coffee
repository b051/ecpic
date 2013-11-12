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
      
      objects.push
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
    
    objects.reverse()
    
    pop = ->
      object = objects.pop()
      return if not object
      
      query = new Parse.Query(CarOwner)
      query.equalTo 'car_number', object.car_number
      query.find().then (results) ->
        if results.length is 0
          return Parse.Promise.as('save')
        
        picked = no
        for result in results
          if result.get('nimpid')
            picked = result
            break
        if not picked
          picked = results[0]
        
        promises = (result.destroy() for result in results if result isnt picked)
        if not promises
          return Parse.Promise.as("skip")
        
        console.log "removing #{promises.length} duplicated record"
        Parse.Promise.when(promises)
      
      .then (results) ->
        if results is "save"
          new CarOwner().save object
        else if results is "skip"
          console.log "skip #{object.car_number}"
        else
          pop()
      
      .then (success) ->
        if success
          console.log "saved #{object.car_number}"
        pop()
      , (err) ->
        console.error err
    
    threads = 20
    for i in [0...threads]
      pop()

# upload("e3.csv")

# 陕A0T030
