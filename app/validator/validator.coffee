###
# @brief Defines a validator, that tries to validate a given
#   json oject with a given scheme
#
# @class Validator
# @file Validator.coffee
# @author Sebastian Pütz (spuetz@uos.de)
# @author Dominik Lips (ddlips@uos.de)
###

JaySchema = require 'jayschema'
FileSystem = require 'fs'

class Validator
  ###
  # @brief C'tor
  #
  # @param file filename of the JSON-schema
  # @param options file rading options
  # @param callBack the callback function for the result of validate
  ###
  constructor: (@file, @options, @callBack) ->
    @schema = JSON.parse FileSystem.readFileSync @file, @options
    @js = new JaySchema()
  
  ###
  # @brief validates the given json objects and calls the callback 
  #   function specified in the c'tor.
  # @param json-object
  ###
  validate: (json) ->
    if @js and @schema
      @js.validate json, @schema, @callBack
    return

  ###
  # @brief loads a test json object and tries to validate it
  # 
  # @param filename of the test json object
  # @param options file reading options
  # @param validator
  ###
  loadAndValidate: (filename, options) ->
    FileSystem.readFile filename, options, (err, data) =>
      if err
        console.log 'parse error'
      else
        @validate(data)
    return

# test callback
callBack = (err, data) ->
  console.log 'Error: '
  console.log err
  console.log 'Data: '
  console.log data

# test the validator
validator = new Validator './xAPI.json', 'utf8', callBack
validator.loadAndValidate './test.json', 'utf8' 
