{Parse} = require './coffee/shared/parse'
{print} = require 'sys'
fs = require 'fs'
readline = require 'readline'

UPDATE = 1

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
    
    _upload = (object, cb) ->
      query = new Parse.Query(CarOwner)
      errcb = (err) ->
        console.log err
        _upload object, cb
      
      query.equalTo 'car_number', object.car_number
      query.select('nimpid').find
        success: (results) ->
          if results.length is 0
            console.log "save #{object.car_number}"
            new CarOwner().save(object).then cb, errcb
            return
          if results.length is 1
            if UPDATE
              console.log "update #{object.car_number}"
              results[0].save(object).then cb, errcb
            else
              console.log "skip #{object.car_number}"
              cb?()
            return
          
          # remove duplicated ones
          picked = no
          for result in results
            if result.get('nimpid')
              picked = result
              break
          if not picked
            picked = results[0]
      
          promises = (result.destroy() for result in results when result isnt picked)
          if UPDATE
            promises.push (picked.save(object))
          
          console.log "removing #{promises.length} duplicated record"
          Parse.Promise.when(promises).then cb, errcb
        error: errcb
      return
    
    pop = (cb) ->
      object = objects.shift()
      return if not object
      _upload object, cb
    
    popL = ->
      pop popL
    
    threads = 8
    for i in [0...threads]
      popL()
      continue

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