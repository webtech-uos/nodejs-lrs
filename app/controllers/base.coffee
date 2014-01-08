Validator = require '../validator/validator'

# Base class for all conttrollers.
#
module.exports = class BaseController

  @validator: new Validator 'app/validator/schemas/'

  # Creates a new controller.
  #
  constructor: (@dbController) -> 

  _prepareResponse: (res) ->
    res.header 'Content-Type', 'application/json'

  send: (res, status, object={}) ->
    @_prepareResponse res
    res.send status, object
