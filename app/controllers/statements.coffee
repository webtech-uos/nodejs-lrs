BaseController = require './base'
StatementMapper = require '../model/statement_mapper'

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
    statements = if typeof req.params[0]? then req.params else [req.params]
    for statement in statements
      errors = {}
      status = 200

      @mapper.save statement, (err, s) =>
        if err
          errors[statement] = err
          status = err.code ? 500
        else
          ids.push s.map.id

        counter++
        if counter == statements.length
          # everything is done, send response
          @send res, status, errors

  # Called whenever the clients requests to get all statements.
  #
  # @see http://mcavage.me/node-restify/#Routing restify for detailed parameter description
  #
  index: (req, res, next) ->
    @mapper.getAll (err, statements) =>
      result = []
      for s in statements
        result.push s.map

      @send res, 200, result

  # Called whenever the clients requests to modify a specific statement.
  #
  # @see http://mcavage.me/node-restify/#Routing restify for detailed parameter description
  #
  update: (req, res, next) ->

    @mapper.save (err, statement) =>
      if err
        #TODO Error check -> database access or no statement with the given id found, etc.
        @send res, error.code ? 500
      else
        @send res, 204

  # Called whenever the clients requests to get a specific statement.
  #
  # @see http://mcavage.me/node-restify/#Routing restify for detailed parameter description
  #
  show: (req, res, next) ->
    # TODO voiding statements with auth...
    @mapper.find req.params.id, (err, statement) =>
      if err
        @send res, error.code ? 500
      else
        @send res, 200, statement

  _prepareResponse: (res) ->
    super res
    res.header 'X-Experience-API-Consistent-Through', new Date(new Date() - 1000*60*60).toISOString()

