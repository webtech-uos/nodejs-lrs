Cradle = require "../../db/cradle.coffee"
# Base class for all conttrollers.
#
module.exports = class BaseController
  # Static DB Instance	
  @db = Cradle.get '127.0.0.1'
  # Creates a new controller.
  #
  constructor: ->