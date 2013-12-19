assert = require "assert"
Validator = require "../../app/validator/validator.coffee"

val = new Validator 'app/validator/schemas/'

describe 'Load a json file with some data', ->
  it 'should return content of file', ->
    content = val.loadJsonFile 'test/validator/validator_class_data.json'
    assert.deepEqual content, {"test": "ok"}
    return

describe "Load a schema from the schema directory", ->
  it 'should return true', ->
    val.loadSchema "UUID.json"
    assert.ok val.js.isRegistered "UUID#"
    return