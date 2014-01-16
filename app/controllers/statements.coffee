BaseController = require './base'
StatementMapper = require '../model/statement_mapper'
logger = require '../logger'

# Controller for route `statements`.
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
    statements = if req.body[0]? then req.body else [req.body]
    errors = {}
    errorOccured = false
    status = 200
    for statement in statements
      @mapper.save statement, (err, createdStatement) =>
        if err
          logger.warn err
          errors[statement] = err
          status = err.code ? 500
          errorOccured = true
        else
          ids.push createdStatement.id

        counter++

        if counter == statements.length
          # everything is done, send response
          # TODO send errors and ids ??
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
    @mapper.save req.body, (err, statement) =>
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

  # Sets the required header fields.
  #
  _prepareResponse: (res) ->
    super res
    res.header 'X-Experience-API-Consistent-Through', new Date(new Date() - 1000*60*60).toISOString()
