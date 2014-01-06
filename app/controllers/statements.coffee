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
    s = new Statement
    # TODO: Modify statement.map accordingly
    s.save =>
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
    statementId = req.params.statementId
    voidedStatementId = req.params.voidedStatmentId ? null
    Statement.find req.params.id, (err, statement) =>
      if err
        #TODO Error check -> database access or no statement with the given id found
      else

      # TODO: Modify statement.map accordingly
      # update conflict -> 409 Conflict
      # if they do not match.
      #s.save =>
        @send res, 204

  # Called whenever the clients requests to get a specific statement.
  #
  # @see http://mcavage.me/node-restify/#Routing restify for detailed parameter description
  #
  show: (req, res, next) ->
    statementId = req.params.statementId ? null
    voidedStatementId = req.params.voidedStatmentId ? null

    # only one of them or none should be defined
    if statementId and voidedStatementId
      @send res, 400
    # send one statement with the statementID
    else if statementId
      Statement.find statementId, (err, statement) =>
        #TODO
        # send single Statement
        @send res, 200
    # send one voided statement with the voidedStatementID
    else if voidedStatementId
      Statement.find voidedStatementId, (err, statement) =>
        #TODO
        # send single voided Statement
        @send res, 200
    # Otherwise returns: StatementResult Object, a list of Statements
    # in reverse chronological order based on "stored" time,
    # subject to permissions and maximum list length.
    # If additional results are available, an IRL to
    # retrieve them will be included in the StatementResult1 Object.
    else
      #TODO send StatementResult Object, (multiple Statements)
      @send res, 200

  _prepareResponse: (res) ->
    super res
    res.header 'X-Experience-API-Consistent-Through', new Date(new Date() - 1000*60*60).toISOString()

