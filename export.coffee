
{Parse} = require './coffee/shared/parse'
{print} = require 'sys'
fs = require 'fs'

fromDate = new Date 2013, 10, 7
toDate = new Date 2013, 10, 8

csv = (d) ->
  date = "#{d.getFullYear()}-#{d.getMonth() + 1}-#{d.getDate()}"
  filename = if d.getMonth() < 9 then "0#{d.getMonth() + 1}" else "#{d.getMonth() + 1}"
  filename += if d.getDate() < 10 then "0#{d.getDate()}" else "#{d.getDate()}"
  filename += ".csv"
  fs.exists filename, (exists) ->
    return if exists
    console.log "downloading #{filename}..."
    Parse.Cloud.run 'export_taiping', date: date,
      success: (json) ->
        # csv = json.map((arr) -> "#{arr[0]},#{arr[1]},#{arr[2]},#{arr[3].toJSON()}").join('\n')
        csv = json.map((arr) -> "#{arr[0]},#{arr[1]}").join('\n')
        fs.writeFile filename, csv
        console.log "#{filename} downloaded"
    
      error: (error) ->
        process.stderr.write error

d = fromDate
while d < toDate
  csv d
  d.setDate(d.getDate() + 1)
