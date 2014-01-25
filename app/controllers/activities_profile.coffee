BaseController = require './base'
logger = require '../logger'

# Controller for route `activities/state`.
#
module.exports = class ActivitiesProfileController extends BaseController

  constrctor: (@dbController, callback = -> ) ->
    callback()


  index: (req, res, next) ->
    res.send 200, ""

  update: (req, res, next) ->
    res.send 200, ""

  create: (req, res, next) ->
    res.send 200, ""

  delete: (req, res, next) ->
    res.send 200, ""

