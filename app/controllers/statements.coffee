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
          res.json status, if errorOccured then errors else ids

  # Called whenever the clients requests to get all statements.
  #
  # @see http://mcavage.me/node-restify/#Routing restify for detailed parameter description
  #
  index: (req, res, next) ->
    id = req.query['statementId']
    if id
      @_sendStatement id, res
    else
      @mapper.getAll (err, statements) =>
        result = []
        for s in statements
          result.push s
        res.json 200, result

  # Called whenever the clients requests to modify a specific statement.
  #
  # @see http://mcavage.me/node-restify/#Routing restify for detailed parameter description
  #
  update: (req, res, next) ->
    @mapper.save req.body, (err, statement) =>
      res.json err?.code ? 204, err

  # Called whenever the clients requests to get a specific statement.
  #
  # @see http://mcavage.me/node-restify/#Routing restify for detailed parameter description
  #
  show: (req, res, next) ->
    @_sendStatement req.params.id, res

  # Sends a specific statement.
  #
  # @private
  #
  _sendStatement: (id, res) ->
    @mapper.find id, (err, statement) =>
      if err
        res.json err.code ? 500, err
      else
        if statement
          res.json 200, statement
        else
          res.json 404, "No statement with id #{id} found!"


  # Sets the required header fields.
  #
  before: (req, res, next) ->
    res.header 'X-Experience-API-Consistent-Through', new Date(new Date() - 1000*60*60).toISOString()
    super
