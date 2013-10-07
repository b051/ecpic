if require?
  {Parse} = require 'parse'
  exports.Parse = Parse
else
  Parse = window.Parse

Parse.initialize process.env.ECPIC_PARSE_APP_ID, process.env.ECPIC_PARSE_APP_KEY