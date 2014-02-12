logger = require '../logger'
util = require 'util'

# Simple base class for all database related entity mappers.
#
# The derived class must specify a DB_PREFIX
# and the respective views.
# See DocumentMapper for details.
#
# All documents are assigned a type as specified in the derived classes.
# Storing a document will automatically assign the correct type while
# views are still able to perform on any types of documents.
# One should restrict the views of derived mappers to their TYPE whenever possible
# and only return the value object instead of the whole document.
#
module.exports = class BaseMapper

  # Creates a new entity-specific mapper.
  #
  # @param callback
  #   called as soon as the mapper is ready to be used
  #
  constructor: (@dbController, callback) ->
    @views = {}
    logger.warn 'no callback supplied for Mapper' unless callback

    if @constructor.VIEWS and @constructor.TYPE
      @dbController.db.save "_design/#{@constructor.TYPE}", @constructor.VIEWS, (err, res) =>
        if err
          logger.error "Error while creating views: #{@constructor.TYPE}"
          logger.error err
          callback(err)
        else
          logger.info "Successfully created views: #{@constructor.TYPE}"
          callback()

      for view of @constructor.VIEWS
        do (view) =>
          @views[view] = (params...) =>
            @dbController.db.view "#{@constructor.TYPE}/#{view}", params...
    else
      logger.error 'Invalid mapper class, VIEWS and TYPE must be defined (class variables)!'

  # Used to save a object of the respective type to the database.
  #
  # @param document
  #  the object to persist
  # @param callback
  #  called as soon as the document is stored
  #
  save: (document, callback) ->
    object =
      value: document
      type: @constructor.TYPE
    @dbController.db.save object, callback

  # Stores a document in the database. Updates its fields if the document already
  # exists.
  #
  # @param id
  #  the document id
  # @param document
  #  the object to persist
  # @param callback
  #  called as soon as the document is stored
  #
  update: (id, document, callback) ->
    object =
      value: document
      type: @constructor.TYPE
      _id: id
    @dbController.db.save object, callback
