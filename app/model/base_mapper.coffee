logger = require '../logger'
util = require 'util'

# Simple base class for all database related entity mappers.
#
# The derived class must specify a DB_PREFIX
# and the respective views.
# See DocumentMapper for details.
#
module.exports = class BaseMapper

  # Creates a new entity-specific mapper.
  # 
  # @param callback
  #   called as soon as the mapper is ready to be used
  # 
  constructor: (callback) ->
    @dbPrefix = @constructor.name
    @views = {}
    logger.warn 'no callback supplied for Mapper' unless callback
    
    if @constructor.VIEWS?
      @dbController.db.save "_design/#{@dbPrefix}", @constructor.VIEWS, (err, res) =>
        if err?
          logger.error "Error while creating views: #{@dbPrefix}"
          logger.error err
          callback(err)
        else
          logger.info "Successfully created views: #{@dbPrefix}"
          callback()

      viewNames = Object.keys(@constructor.VIEWS)
      for view in viewNames
        do (view) =>
          @views[view] = (params...) =>
            @dbController.db.view "#{@dbPrefix}/#{view}", params...
    else
      logger.error 'Invalid mapper class, VIEWS must be defined!'
