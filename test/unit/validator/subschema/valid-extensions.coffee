assert = require "assert"
Validator = require "../../../../app/validator/validator.coffee"

val = new Validator 'app/validator/schemas/'

validExtensions =
  isISBN : 
    "http://id.tincanapi.com/extension/isbn": "978-1449304195"
  isInteger:
    "http://id.tincanapi.com/extension/ending-point": 36
    "http://id.tincanapi.com/extension/starting-point": 48
  isObject:
    "http://id.tincanapi.com/extension/powered-by": 
      "name": "Tin Can Engine"
      "homePage": "http://tincanapi.com/lrs-lms/lrs-for-lmss-home/"
      "version": "2012.1.0.5039b"
        
  

describe 'Extensions', ->

  describe 'with ISBN', ->
    it 'should be valid', (done) ->
      val.validateWithSchema validExtensions.isISBN, "Extensions", done

  describe 'with integer values', ->
    it 'should be valid', (done) ->
      val.validateWithSchema validExtensions.isInteger, "Extensions", done

  describe 'with object', ->
    it 'should be valid', (done) ->
      val.validateWithSchema validExtensions.isObject, "Extensions", done
