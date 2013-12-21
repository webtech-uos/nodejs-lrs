assert = require "assert"
Validator = require "../../../app/validator/validator.coffee"


describe 'Validator class:', ->
  
  val = new Validator 'app/validator/schemas/'
  
  describe 'Load a json file with some data', ->
    it 'should return content of file', ->
      content = val.loadJsonFile 'test/unit/validator/validator_class_data.json'
      assert.deepEqual content, {"test": "ok"}
      return

  describe "Load a schema from the schema directory", ->
    it 'should return true', ->
      val.loadSchema "UUID"
      assert.ok val.js.isRegistered "UUID#"
      return

  describe "Load a schema with external references", ->
    it 'should load all dependencies', (done) ->
      val.validateWithSchema {}, "xAPI", (err) ->
        try
          assert.ok val.js.isRegistered("Agent#")
          assert.ok val.js.isRegistered("UUID#")
          assert.ok val.js.isRegistered("IFI#")
          assert.ok val.js.isRegistered("Agent#")
          assert.ok val.js.isRegistered("Group#")
        catch Error
          done(Error)
          return
        done()