logger = require '../logger'
util = require 'util'

module.exports = class BaseMapper

  constructor: (callback) ->
    if @views? and @dbPrefix?
      @dbController.db.save "_design/#{@dbPrefix}", @views, (err, res) =>
        if err?
          logger.error "Error while creating views: #{@dbPrefix}"
          logger.error err
          callback(err)
        else
          logger.info "Successfully created views: #{@dbPrefix}"
          callback()

      viewNames = Object.keys(@views)
      for view in viewNames
        do (view) =>
          @[view] = (params...) =>
            @dbController.db.view "#{@dbPrefix}/#{view}", params...