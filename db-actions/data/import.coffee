fs = require 'fs'
http = require 'http'
$ = require 'jquery'

readFile= ->
  fs.readFileSync 'db-actions/data/exampleData.json', 'utf8'

postData= ->
  jsonFile = readFile()
  $.ajax
    url: 'http://localhost:5984/wt2/_bulk_docs'
    type: 'POST'
    contentType: "application/json"
    dataType: "json"
    data : jsonFile
    success: (data, status, response) ->
      #console.log response
      #console.log data
      console.log status
      console.log "JSON imported."
    error: (error) ->
      console.log error
      console.log "JSON NOT imported."

createDB= ->
  jsonFile = readFile()
  $.ajax
    url: 'http://localhost:5984/wt2/'
    type: 'PUT'
    success: (data, status, response) ->
        #console.log response
        #console.log data
        #console.log status
        console.log "database 'wt2' created."
        postData()
    error: (error) ->
        console.log error
        console.log "database not created."


# start the process:
createDB()
