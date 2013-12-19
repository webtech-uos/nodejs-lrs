fs = require 'fs'
http = require 'http'
$ = require 'jquery'


readFile= (fileName) ->
  fs.readFileSync fileName, 'utf8'


viewImport= ->
  viewFile = readFile('db-actions/views/views_find_by.json')
  $.ajax
    url: 'http://localhost:5984/wt2/_design/find_by/'
    type: 'PUT'
    contentType: "application/json"
    dataType: "json"
    data : viewFile
    success: (data, status, response) ->
      #console.log response
      #console.log data
      console.log status
      console.log "views imported."
    error: (error) ->
      console.log error
      console.log "views NOT imported."


postData= ->
  exapleDataFile = readFile('db-actions/data/exampleData.json')
  $.ajax
    url: 'http://localhost:5984/wt2/_bulk_docs'
    type: 'POST'
    contentType: "application/json"
    dataType: "json"
    data : exapleDataFile
    success: (data, status, response) ->
      #console.log response
      #console.log data
      console.log status
      console.log "JSON imported."
      viewImport()
    error: (error) ->
      console.log error
      console.log "JSON NOT imported."


createDB= ->
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
