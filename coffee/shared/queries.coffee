#ifndef CloudCode
if require?
  models = require('./parse')
  _localParse = models.Parse
else
  _localParse = Parse
#endif_localParse = Parse

queryOwners = ->
  now = new Date()
  now = new Date(now.getFullYear(), now.getMonth(), now.getDate() + (now.getUTCHours() >= 16))
  month = now.getMonth()
  date = now.getDate()
  
  thisMonth = new _localParse.Query("CarOwner")
  thisMonth.equalTo 'first_month', month + 1
  thisMonth.lessThan 'first_day', date
  thisMonth.ascending 'first_day'
  
  lastMonth = new _localParse.Query("CarOwner")
  lastMonth.lessThanOrEqualTo 'first_month', (month + 11) % 12 + 1
  lastMonth.descending 'first_day'
  
  query = Parse.Query.or thisMonth, lastMonth, new Parse.Query("CarOwner")
  query.doesNotExist "track"

_dateQuery = (date) ->
  query = new _localParse.Query("CarOwner")
  query.exists('nimpid')
  fromDate = new Date(Date.UTC(date.getFullYear(), date.getMonth(), date.getDate(), 0))
  toDate = new Date(Date.UTC(date.getFullYear(), date.getMonth(), date.getDate() + 1, 0))
  query.greaterThanOrEqualTo('used', fromDate)
  query.lessThan('used', toDate)
  query

queryDateCount = (date, callback) ->
  query = _dateQuery(date)
  query.notEqualTo 'nimpid', 'qq'
  
  query.count
    success: (count) ->
      callback?(query, count, null)
    error: (error) ->
      callback?(query, 0, error)


queryQQDateCount = (date, callback) ->
  query = _dateQuery(date)
  query.equalTo 'nimpid', 'qq'
  query.count
    success: (count) ->
      callback?(query, count, null)
    error: (error) ->
      callback?(query, 0, error)


scheduleCount = (date) ->
  days = (date.getTime() - date.getTimezoneOffset() * 60000) / 86400000 - 15873
  if 76 < days < 106
    sepSchedule = [766,757,678,645,542,422,498,781,728,677,645,542,423,500,700,693,655,400,450,500,700,723,760,753,735,618,500,485,455]
    return sepSchedule[Math.floor(days) - 77]
  
  performance = Math.floor(days / 7) * .05
  ctr = [.17, .1641, .1692, .1611, .1362, .1072, .1255][Math.floor(days) % 7]
  Math.round(7500 * ctr * performance)

if require?
  exports.scheduleCount = scheduleCount
  exports.queryOwners = queryOwners
  exports.queryDateCount = queryDateCount
  exports.queryQQDateCount = queryQQDateCount
else
  window.scheduleCount = scheduleCount
  window.queryOwners = queryOwners
  window.queryDateCount = queryDateCount
  window.queryQQDateCount = queryQQDateCount