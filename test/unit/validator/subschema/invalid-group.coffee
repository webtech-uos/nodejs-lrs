assert = require "assert"
Validator = require "../../../../app/validator/validator.coffee"
util = require "util"

val = new Validator 'app/validator/schemas/'

invalid = (err, done) ->
  if err?
    done()
  else
    done(new Error "Should not be valid")

invalidGroup =
  isEmpty: {}
  isAnonymous:
    objectTypeMissing: 
      member: [
        { "objectType":"agent", "mbox":"mailto:test@test.test" },
        { "name":"Martin", "openid":"http://martin.test/martin" },
        { "account": { "homePage":"demo.studip.de", "name":"test_autor" } }
      ]
    memberMissing:
      objectType: "Group"
    memberEmpty:
      objectType: "Group"
      member: []
  isIdentified:
    invalidMbox:
      objectType: "Group"
      mbox: "mado:test@test.de"
      member: [
        { "objectType":"agent", "mbox":"mailto:test@test.test" },
        { "name":"Martin", "openid":"http://martin.test/martin" },
        { "account": { "homePage":"demo.studip.de", "name":"test_autor" } }
      ]
  
describe 'Anonymous Group', ->

  describe 'is empty', ->
    it 'should be invalid', (done) ->
      val.validateWithSchema invalidGroup.isEmpty, "Group", (err) ->
        invalid err, done

  describe 'has empty member', ->
    it 'should be invalid', (done) ->
      val.validateWithSchema invalidGroup.isAnonymous.memberEmpty, "Group", (err) ->
        invalid err, done

  describe 'with missing', ->
    describe 'objectType', ->
      it 'should be invalid', (done) ->
        val.validateWithSchema invalidGroup.isAnonymous.objectTypeMissing, "Group", (err) ->
          invalid err, done
    describe 'member', ->
      it 'should be invalid', (done) ->
        val.validateWithSchema invalidGroup.isAnonymous.memberMissing, "Group", (err) ->
          invalid err, done

describe 'Identified Group', ->

  describe 'with invalid mbox', ->
    it 'should be invalid', (done) ->
      val.validateWithSchema invalidGroup.isIdentified.invalidMbox, "Group", (err) ->
        invalid err, done
