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

_dateQuery = (cls, date) ->
  query = new _localParse.Query(cls)
  query.exists('nimpid')
  fromDate = new Date(Date.UTC(date.getFullYear(), date.getMonth(), date.getDate(), 0))
  toDate = new Date(Date.UTC(date.getFullYear(), date.getMonth(), date.getDate() + 1, 0))
  query.greaterThanOrEqualTo('used', fromDate)
  query.lessThan('used', toDate)
  query

queryDateCount = (cls, date, condition, callback) ->
  query = _dateQuery(cls, date)
  condition?query
  
  query.count
    success: (count) ->
      callback?(query, count, null)
    error: (error) ->
      callback?(query, 0, error)

queryEcpicCount = (date, callback) ->
  queryDateCount 'CarOwner', date, (query) ->
    query.notEqualTo 'nimpid', 'qq'
  , callback

queryQQDateCount = (date, callback) ->
  queryDateCount 'CarOwner', date, (query) ->
    query.equalTo 'nimpid', 'qq'
  , callback

scheduleCount = (date) ->
  days = (date.getTime() - date.getTimezoneOffset() * 60000) / 86400000 - 15873
  # if days <= 136
  #   sepSchedule = [300,298,288,285,246,186,359,335,312,298,248,188,221,363,338,315,301,251,189,224,369,344,318,304]
  #   return sepSchedule[Math.floor(days) - 113]
  
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