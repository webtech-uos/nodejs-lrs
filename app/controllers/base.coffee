Validator = require '../validator/validator'

# Base class for all conttrollers.
#
module.exports = class BaseController
  
  # Creates a new controller.
  #
  constructor: ->
    
  _prepareResponse: (res) ->
    res.header 'Content-Type', 'application/json'
    
  send: (res, params...) ->
    @_prepareResponse res
    res.send.apply(res, params)
