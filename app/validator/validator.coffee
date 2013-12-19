###
# Defines a validator, that tries to validate a given
#   json oject with a given scheme
#
# @author Sebastian Pütz (spuetz@uos.de)
# @author Dominik Lips (dlips@uos.de)
###

JaySchema = require 'jayschema'
FileSystem = require 'fs'

module.exports = class Validator
  # C'tor. The schemaDir has to be relativ to the file which uses this 
  # class.
  #
  # @param [String] schemaDir Relativ path to the schema directory.
  constructor: (@schemaDir) ->
    @js = new JaySchema()
    @schema = "xAPI#"
  
  # Validates the given json objects and calls the callback 
  #   function specified.
  #
  # @param [Object] json JSON-Object to validate.
  # @param [Function] callback Callback to invoke after validation.
  validate: (json, callback) ->
    if @js and @schema
      @js.validate json, @schema, callback
    return

  # Loads a file and parse the content as JSON.
  # 
  # @param [String] path Path to the file. 
  loadJsonFile: (path) ->
    JSON.parse FileSystem.readFileSync path, 'utf8'

  # Load a schema and register it in the validator.
  # 
  # @param [String] filename Filename of the schema in the schema directory.
  loadSchema: (filename) ->
    schema = @loadJsonFile "#{@schemaDir}schemas/#{filename}"
    @js.register schema