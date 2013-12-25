assert = require "assert"
Validator = require "../../../../app/validator/validator.coffee"

val = new Validator 'app/validator/schemas/'

invalid = (err, done) ->
  if err?
    done()
  else
    done(new Error "Should not be valid")

invalidExtensions =
  isNoIRI : 
    "hasdsadad": "978-1449304195"
        
describe 'Extensions', ->

  describe 'with abitrary property', ->
    it 'should be invalid', (done) ->
      val.validateWithSchema invalidExtensions.isNoIRI, "Extensions", (err) ->
        invalid err, done
