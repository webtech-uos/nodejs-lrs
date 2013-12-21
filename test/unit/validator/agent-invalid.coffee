assert = require "assert"
Validator = require "../../../app/validator/validator.coffee"

val = new Validator 'app/validator/schemas/'

Agent =
  isEmpty: {}
  isAccount:
    homePageMissing: 
      "account": 
        "name": "1625378"
    nameMissing: 
      "account": 
        "homePage": "http://www.asmple.com"
  isOpenID:
    isEmpty:
      "openid":"" 
    isInvalid:
      "openid":"test&*(^&*^@&#^&^@" 
  isMbox:
    isEmpty:
      "mbox":""
    isInvalid:
      "mbox":"mailasdasdasdto:mail@example.com"
  isMboxSha1sum:
    isEmpty:
      "mbox_sha1sum":""
    isInvalidHash:
      "mbox_sha1sum":"c1e62d41da353afdd69"
  hasMultiple:
    "openid":"http://my.openid.test/12345678-1234-5678" 
    "mbox":"mailto:mail@example.com"
  withOptional:
    invalidObjectType:
      "objectType" : "Dude"
      "mbox":"mailto:mail@example.com"
    weirdProperty:
      "foo" : "bar"
      "mbox":"mailto:mail@example.com"
    
describe 'Agent', ->

  describe 'is empty', ->
    it 'should be invalid', (done) ->
      val.validateWithSchema Agent.isEmpty, "Agent", (err) ->
        if err?
          done()
        else
          done({})

  describe 'is account', ->
    describe 'name missing', ->
      it 'should be invalid', (done) ->
        val.validateWithSchema Agent.isAccount.nameMissing, "Agent", (err) ->
          if err?
            done()
          else
            done({})
    describe 'homepage missing', ->
      it 'should be invalid', (done) ->
        val.validateWithSchema Agent.isAccount.homePageMissing, "Agent", (err) ->
          if err?
            done()
          else
            done({})

  describe 'is openid', ->
    describe 'empty', ->
      it 'should be invalid', (done) ->
        val.validateWithSchema Agent.isOpenID.isEmpty, "Agent", (err) ->
          if err?
            done()
          else
            done({})
    describe 'invalid url', ->
      it 'should be invalid', (done) ->
        val.validateWithSchema Agent.isOpenID.isInvalid, "Agent", (err) ->
          if err?
            done()
          else
            done({})

  describe 'is mbox', ->
    describe 'empty', ->
      it 'should be invalid', (done) ->
        val.validateWithSchema Agent.isMbox.isEmpty, "Agent", (err) ->
          if err?
            done()
          else
            done({})
    describe 'invalid url', ->
      it 'should be invalid', (done) ->
        val.validateWithSchema Agent.isMbox.isInvalid, "Agent", (err) ->
          if err?
            done()
          else
            done({})
    describe "with optional field `objectType` unequal to `Agent`", -> 
      it 'should be invalid', (done) ->
        val.validateWithSchema Agent.withOptional.invalidObjectType, "Agent", (err) ->
          if err?
            done()
          else
            done({})
    describe "with additional property", -> 
      it 'should be invalid', (done) ->
        val.validateWithSchema Agent.withOptional.weirdProperty, "Agent", (err) ->
          if err?
            done()
          else
            done({})
    
  describe 'is mbox_sha1sum', ->
    describe 'empty', ->
      it 'should be invalid', (done) ->
        val.validateWithSchema Agent.isMboxSha1sum.isEmpty, "Agent", (err) ->
          if err?
            done()
          else
            done({})
    describe 'invalid url', ->
      it 'should be invalid', (done) ->
        val.validateWithSchema Agent.isMboxSha1sum.isInvalidHash, "Agent", (err) ->
          if err?
            done()
          else
            done({})

  describe 'has mixed properties', ->
    it 'should be invalid', (done) ->
      val.validateWithSchema Agent.hasMultiple, "Agent", (err) ->
        if err?
          done()
        else
          done({})