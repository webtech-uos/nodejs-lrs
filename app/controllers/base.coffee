Validator = require '../validator/validator'

# Base class for all conttrollers.
#
module.exports = class BaseController

  # Creates a new controller.
  #
  constructor: ->

  _prepareResponse: (res) ->
    res.header 'Content-Type', 'application/json'

  send: (res, status, object={}) ->
    @_prepareResponse res
    res.send status, object
