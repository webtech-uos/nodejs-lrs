BaseController = require './base'

module.exports = class AboutController extends BaseController

  # Call when a client requests LRS information
  #
  # @see https://github.com/adlnet/xAPI-Spec/blob/master/xAPI.md#77-about-resource
  #
  info: (req, res, next) ->
    @send res, 200, version: '1.0.1'
