JaySchema = require 'jayschema'
fs = require 'fs'

# Defines a validator, that tries to validate a given
# JSON-object with a given scheme.
#
# @author Sebastian Pütz (spuetz@uos.de)
# @author Dominik Lips (dlips@uos.de)
module.exports = class Validator
  
  # C'tor. The schemaDir has to be relativ to the file which uses this 
  # class.
  #
  # @param [String] schemaDir Relativ path to the schema directory.
  constructor: (@schemaDir) ->
    @js = new JaySchema (ref, callback) =>
      if not @js.isRegistered ref+"#"
        fs.readFile @schemaDir + ref + ".json", "utf8", (err, data) ->
          if err?
            callback err
          else
            callback null, JSON.parse(data)
    @schema = "xAPI"
  
  # Validates the given json objects against the default `xAPI#` schema.
  #
  # @param [Object] json JSON-Object to validate.
  # @param [Function] callback Callback to invoke after validation.
  validate: (json, callback) ->
    @validateWithSchema json, @schema, callback
    return

  # Validates the given json objects against a given schema.
  # The schema can be the id of a previously loaded schema or an JSON-Object
  # which is a valid JSON-Schema.
  # 
  # @param [Object] json JSON-Object to validate.
  # @param [String, Object] schema Schema to validate.
  # @param [Function] callback Callback to invoke after validation.
  validateWithSchema: (json, schema, callback) ->
    if schema?
      unless @js.isRegistered schema
        @loadSchema schema
      @js.validate json, schema, callback
    else
      throw new Error "No schema specified!"
    return  

  # Loads a file and parse the content as JSON.
  # 
  # @param [String] path Path to the file. 
  loadJsonFile: (path) ->
    JSON.parse fs.readFileSync path, 'utf8'

  # Load a schema and register it in the validator.
  # 
  # @param [String] filename Filename of the schema in the schema directory.
  loadSchema: (filename) ->
    schema = @loadJsonFile "#{@schemaDir}#{filename}.json"
    @js.register schema