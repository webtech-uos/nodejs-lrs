BaseController = require './base'
Statement = require '../model/statement'

# Sample controller for route `statements`.
#
# TODO: Validate incoming JSON
#
module.exports = class StatementsController extends BaseController

  # Called whenever the clients requests to add a new statement.
  #
  # @see http://mcavage.me/node-restify/#Routing restify for detailed parameter description
  #
  create: (req, res, next) ->
    counter = 0

    # TODO: check first all ids ?
    res.params.ids = []
    for statement in req.params.statements
      s = new (Statement)(statement)

      s.save (err, statement) =>
        if err
          # TODO collect errors, conflicts, etc.
          null
        else
          res.params.ids.push s.map.id

        counter++
        if counter == req.params.statements.length
        # everything is done, send response
          @send res, 200

  # Called whenever the clients requests to get all statements.
  #
  # @see http://mcavage.me/node-restify/#Routing restify for detailed parameter description
  #
  index: (req, res, next) ->
    Statement.all (err, statements) =>
      result = []
      for s in statements
        result.push s.map

      res.body = JSON.stringify result
      console.log "sending #{result.length} statements..."
      @send res, 200

  # Called whenever the clients requests to modify a specific statement.
  #
  # @see http://mcavage.me/node-restify/#Routing restify for detailed parameter description
  #
  update: (req, res, next) ->
    # TODO id or statementId ???
    s = new (Statement)(req.params) # TODO Is this correct?
    # TODO validate check if id is set, id must be set
    s.save (err, statement) =>
      if err
        #TODO Error check -> database access or no statement with the given id found, etc.
        null
      else
        @send res, 204

  # Called whenever the clients requests to get a specific statement.
  #
  # @see http://mcavage.me/node-restify/#Routing restify for detailed parameter description
  #
  show: (req, res, next) ->
    # TODO voiding statements with auth...
    Statement.find req.params.id, (err, statement) =>
      if err
        #TODO ERROR code etc.
        null
      else
        res.body = JSON.stringify statement.map
        @send res, 200

  _prepareResponse: (res) ->
    super res
    res.header 'X-Experience-API-Consistent-Through', new Date(new Date() - 1000*60*60).toISOString()

