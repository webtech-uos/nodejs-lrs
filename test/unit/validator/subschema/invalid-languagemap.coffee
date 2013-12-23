assert = require "assert"
Validator = require "../../../../app/validator/validator.coffee"
util = require "util"

val = new Validator 'app/validator/schemas/'

invalid = (err, done) ->
  if err?
    done()
  else
    done(new Error "Should not be valid")

invalidEmpty = {}

invalidOne =
  "de-419-DE": "(two region tags)"

invalidTwo =
  "a-DE": "(use of a single-character subtag in primary position; note
      that there are a few grandfathered tags that start with i- that
      are valid)"
#invalidThree =
#  "ar-a-aaa-b-bbb-a-ccc": "(two extensions with same single-letter
#      prefix)"

describe 'LanguageMap', ->

  describe 'is empty', ->
    it 'should be invalid', (done) ->
      val.validateWithSchema invalidEmpty, "LanguageMap", (err) ->
        invalid err, done
  
  describe 'with two region tags', ->
    it 'should be invalid', (done) ->
      val.validateWithSchema invalidOne, "LanguageMap", (err) ->
        invalid err, done
  
  describe 'with single charactor subtag', ->
    it 'should be invalid', (done) ->
      val.validateWithSchema invalidTwo, "LanguageMap", (err) ->
        invalid err, done
  
  # describe 'with two extensions with single-letter prefix', ->
  #   it 'should be invalid', (done) ->
  #     val.validateWithSchema invalidThree, "LanguageMap", (err) ->
  #       invalid err, done
  
  
  
      