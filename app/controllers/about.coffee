BaseController = require './base'

module.exports = class AboutController extends BaseController

  constrctor: (@dbController, callback = -> ) ->
    callback()
  # Call when a client requests LRS information
  #
  # @see https://github.com/adlnet/xAPI-Spec/blob/master/xAPI.md#77-about-resource
  #
  info: (req, res, next) ->
    res.json 200, version: require('../config').server.xApiVersion
