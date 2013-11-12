
{Parse} = require './coffee/shared/parse'
{print} = require 'sys'
fs = require 'fs'
https = require 'https'

option '-d', '--date [yyyy-MM-dd]', 'export from date'
option '-f', '--file', 'upload file'

task 'csv', 'export CSV file from date', (options) ->
  console.log options
  return
  date = options.arguments[0]
  Parse.Cloud.run 'export', date: date,
    success: (json) ->
      csv = json.map((arr) -> "#{arr[0]},#{arr[1]},#{arr[2]},#{arr[3].toJSON()}").join('\n')
      d = new Date(date)
      filename = if d.getMonth() < 11 then "0#{d.getMonth() + 1}" else "#{d.getMonth() + 1}"
      filename += if d.getDate() < 10 then "0#{d.getDate()}" else "#{d.getDate()}"
      filename += ".csv"
      fs.writeFile filename, csv
    
    error: (error) ->
      process.stderr.write error

task 'logentries', 'logentries', (options) ->
  d = options.arguments[0]
  from = new Date(d)
  to = from
  to.setMonth(from.getMonth() + 1)
  to.setSeconds(-1)
  options =
    hostname:'api.logentries.com'
    port: 443
    method: 'GET'
    path: "/16cea008-1ad4-44f2-96c9-15f246ac2d8c/hosts/ecpic/52e3ea19-d535-4052-bcba-e8595edbc8cc/?start=#{from.getTime()}&end=#{to.getTime()}"
  req = https.request options, (res) ->
    res.on 'data', (d) ->
      process.stdout.write(d)
  req.end()
  req.on 'error', (e) ->
    console.error e


login = (cb)->
  Parse.User.logIn 'sundaheng731@gmail.com', 'abcdef',
    success: ->
      cb?()
    error: (error) ->
      console.log error

task 'reset', (options) ->
  reset = (cb) ->
    new Parse.Query("CarOwner2").startsWith('track', 'track').find
      success: (results) ->
        results.forEach (result) ->
          result.unset('track')
          result.save(null)
        cb? results.length
      error: (error) ->
        console.error error
        cb? 0
  login ->
    total = 0
    resetLoop = ->
      reset (num) ->
        total += num
        if num is 100
          resetLoop()
        else
          console.log total
    resetLoop()

task 'used', (options) ->
  login ->
    query = new Parse.Query("CarOwner")
    query.exists('used')
    query.count
      success: (count) ->
        console.log count
      error: (error) ->
        console.log error

task 'tracked', (options) ->
  login ->
    query = new Parse.Query("CarOwner")
    query.exists('track')
    query.count
      success: (count) ->
        console.log count
      error: (error) ->
        console.log error

task 'unused', (options) ->
  login ->
    query = new Parse.Query("CarOwner")
    query.doesNotExist('used')
    query.count
      success: (count) ->
        console.log count
      error: (error) ->
        console.log error
