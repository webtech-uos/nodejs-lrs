assert = require "assert"
Validator = require "../../../../app/validator/validator.coffee"

val = new Validator 'app/validator/schemas/'

validAgent =
  isAccount: 
    "account": 
      "homePage": "http://www.example.com"
      "name": "1625378"
  isOpenID:
    "openid":"http://my.openid.test/12345678-1234-5678" 
  isMbox:
    "mbox":"mailto:mail@example.com"
  isMboxSha1sum:
    "mbox_sha1sum":"c10c76ce17e59c4d304ba37e62d41da353afdd69"
  withOptional:
    name:
      "name" : "Tester"
      "mbox_sha1sum":"c10c76ce17e59c4d304ba37e62d41da353afdd69"
    objectType:
      "objectType" : "Agent"
      "mbox_sha1sum":"c10c76ce17e59c4d304ba37e62d41da353afdd69"
    both:
      "objectType" : "Agent"
      "name" : "Tester"
      "mbox_sha1sum":"c10c76ce17e59c4d304ba37e62d41da353afdd69"    


describe 'Agent', ->

  describe 'is account', ->
    it 'should be valid', (done) ->
      val.validateWithSchema validAgent.isAccount, "Agent", done

  describe 'is openID', ->
    it 'should be valid', (done) ->
      val.validateWithSchema validAgent.isOpenID, "Agent", done

  describe 'is mbox', ->
    it 'should be valid', (done) ->
      val.validateWithSchema validAgent.isMbox, "Agent", done
  
  describe 'is mbox_sha1sum', ->
    it 'should be valid', (done) ->
      val.validateWithSchema validAgent.isMboxSha1sum, "Agent", done
    
    describe 'with optional field', ->
      
      describe '`name`', ->
        it 'should be valid', (done) ->
          val.validateWithSchema validAgent.withOptional.name, "Agent", done
      describe '`objectType`', ->
        it 'should be valid', (done) ->
          val.validateWithSchema validAgent.withOptional.objectType, "Agent", done
      describe '`name` and `objectType`', ->
        it 'should be valid', (done) ->
          val.validateWithSchema validAgent.withOptional.both, "Agent", done
    