BaseController = require './base'
StatementMapper = require '../model/statement_mapper'
logger = require '../logger'

# Sample controller for route `statements`.
#
# TODO: Validate incoming JSON
#
module.exports = class StatementsController extends BaseController

  constructor: ->
    super
    @mapper = new StatementMapper(@dbController)

  # Called whenever the clients requests to add a new statement.
  #
  # @see http://mcavage.me/node-restify/#Routing restify for detailed parameter description
  #
  create: (req, res, next) ->
    counter = 0

    ids = []
    statements = if req.params[0]? then req.params else [req.params]
    errors = {}
    errorOccured = false
    status = 200
    for statement in statements
      BaseController.validator.validateWithSchema statement, "xAPIStatement", (err) =>
        if err
          @send res, 400, err
        else
          @mapper.save statement, (err, createdStatement) =>
            if err
              logger.error err
              errors[statement] = err
              status = err.code ? 500
              errorOccured = true
            else
              ids.push createdStatement.id
    
            counter++
    
            if counter == statements.length
              # everything is done, send response
              @send res, status, if errorOccured then errors else ids

  # Called whenever the clients requests to get all statements.
  #
  # @see http://mcavage.me/node-restify/#Routing restify for detailed parameter description
  #
  index: (req, res, next) ->
    @mapper.getAll (err, statements) =>
      result = []
      for s in statements
        result.push s

      @send res, 200, result

  # Called whenever the clients requests to modify a specific statement.
  #
  # @see http://mcavage.me/node-restify/#Routing restify for detailed parameter description
  #
  update: (req, res, next) ->
    @mapper.save req.params, (err, statement) =>
      # TODO: Handle Error
      @send res, 204

  # Called whenever the clients requests to get a specific statement.
  #
  # @see http://mcavage.me/node-restify/#Routing restify for detailed parameter description
  #
  show: (req, res, next) ->
    @mapper.find req.params.id, (err, statement) =>
      # TODO: Handle Error
      @send res, 200, statement

  _prepareResponse: (res) ->
    super res
    res.header 'X-Experience-API-Consistent-Through', new Date(new Date() - 1000*60*60).toISOString()

