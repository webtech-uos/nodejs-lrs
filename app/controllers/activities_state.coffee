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
    badParam = false

    for k of req.query
      unless k in ['stateId','activityId','agent','registration']
        badParam = k
        break
    if badParam
      res.json 400, "Query parameter \"#{badParam}\" not allowed here."
    else
      # Required
      id = req.query.stateId
      activityId = req.query.activityId
      agent = req.query.agent

      # Optional
      registration = req.query.registration

      # No StateId given
      # GET will return the available ids
      if id is undefined
        res.send 200, 'Alle verfügbaren IDs'
      # StateId is given
      else
        # TODO:
        # ActivityId, agent, stateId required
        @mapper.find id, (err, state) ->
          if err
            logger.error err
            res.send 400, ''
          else
            res.send 200, state

  update: (req, res, next) ->
    res.send 200, ""

  create: (req, res, next) ->
    res.send 200, ""

  delete: (req, res, next) ->
    res.send 200, ""

