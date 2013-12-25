assert = require "assert"
Validator = require "../../../../app/validator/validator.coffee"
util = require "util"

val = new Validator 'app/validator/schemas/'

valid = (err, done) ->
  if err?
    done(new Error(util.inspect(err)))
  else
    done()

validGroup =
  isAnonymn:
    minimal:
      objectType: "Group" 
      member: [
        { "objectType":"agent", "mbox":"mailto:test@test.test" },
        { "name":"Martin", "openid":"http://martin.test/martin" },
        { "account": { "homePage":"demo.studip.de", "name":"test_autor" } }
      ]
  isIdentified:
    minimal:
      objectType: "Group" 
      mbox: "mailto:test@example.com"
      member: [
        { "objectType":"agent", "mbox":"mailto:test@test.test" },
        { "name":"Martin", "openid":"http://martin.test/martin" },
        { "account": { "homePage":"demo.studip.de", "name":"test_autor" } }
      ]
    noMembers:
      objectType: "Group" 
      mbox: "mailto:test@example.com"
      
describe 'Anonymous Group', ->

  describe 'with minimal fields', ->
    it 'should be valid', (done) ->
      val.validateWithSchema validGroup.isAnonymn.minimal, "Group", (err) ->
        valid err, done

describe 'Identified Group', ->

  describe 'with minimal fields', ->
    it 'should be valid', (done) ->
      val.validateWithSchema validGroup.isIdentified.minimal, "Group", (err) ->
        valid err, done

  describe 'without members', ->
    it 'should be valid', (done) ->
      val.validateWithSchema validGroup.isIdentified.noMembers, "Group", (err) ->
        valid err, done

  
  