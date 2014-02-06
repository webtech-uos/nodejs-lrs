BaseController = require './base'
logger = require '../logger'
DocumentMapper = require '../model/document_mapper'

# Controller for route `activities/state`.
#
module.exports = class ActivitiesStateController extends BaseController

  # Creates a new controller.
  #
  constructor: (@dbController, callback) ->
    logger.warn "no callback supplied for new activities-controller" unless callback
    dbCon = @dbController
    super(dbCon, (err) =>
      if err
        callback err
      else
        @mapper = new DocumentMapper dbCon, callback
    )


  index: (req, res, next) ->
    console.log req
    res.send 200, ""

  update: (req, res, next) ->
    res.send 200, ""

  create: (req, res, next) ->
    res.send 200, ""

  delete: (req, res, next) ->
    res.send 200, ""

