{Parse} = require './coffee/shared/parse'
{print} = require 'sys'
fs = require 'fs'
readline = require 'readline'

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
    
    pop = ->
      object = objects.pop()
      return if not object
      
      query = new Parse.Query(CarOwner)
      query.equalTo 'car_number', object.car_number
      query.select('nimpid').find().then (results) ->
        promise = Parse.Promise.as(results.length)
        if results.length in [0, 1]
          return promise
        
        picked = no
        for result in results
          if result.get('nimpid')
            picked = result
            break
        if not picked
          picked = results[0]
        
        promises = (result.destroy() for result in results if result isnt picked)
        console.log "removing #{promises.length} duplicated record"
        Parse.Promise.when(promises).then ->
          promise
      .then (results) ->
        if results is 0
          new CarOwner().save(object)
        else if results is 1
          console.log "skip #{object.car_number}"
        pop()
        return
      , (err) ->
        pop()
        return
    
    threads = 2
    for i in [0...threads]
      pop()


rl = readline.createInterface
  input: process.stdin
  output: process.stdout

fs.readdir '.', (err, files) ->
  csvs = []
  question = "which files to upload?"
  i = 0
  files.forEach (file) ->
    if file.match /^[^\.].+\.csv$/
      csvs.push file
      question += "\n#{++i}. #{file}"
  question += '\n'
  if csvs.length
    rl.question question, (answer) ->
      file = csvs[answer - 1]
      console.log "uploading #{file}..."
      upload file
  else
    console.log "you have no csv files in current directory"