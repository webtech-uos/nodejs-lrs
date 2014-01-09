
# Base class for all conttrollers.
#
module.exports = class BaseController


  # Creates a new controller.
  #
  constructor: (@dbController) ->

  # Called before each send to set header field and prepare the response.
  #
  _prepareResponse: (res) ->
    res.header 'Content-Type', 'application/json'

  # Should be used instead of `res.send`, triggers any nessecary preparations.
  #
  send: (res, status, object={}) ->
    @_prepareResponse res
    res.send status, object
