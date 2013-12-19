assert = require "assert"
Validator = require "../../app/validator/validator.coffee"

val = new Validator '../../app/validator/'

describe 'loadJsonFile', ->
  it 'Should return content of file', ->
    content = val.loadJsonFile './validator_class_data.json'
    assert.deepEqual content, {"test": "ok"}
    return

describe "loadSchema", ->
  it 'Should return true', ->
    val.loadSchema "UUID.json"
    assert.ok val.js.isRegistered "UUID#"
    return