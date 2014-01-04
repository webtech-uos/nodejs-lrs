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
    Statement.all (statements) =>
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
    s = Statement.find req.params.id, (statement) =>
      # TODO: Modify statement.map accordingly
      s.save =>
        @send res, 204

  # Called whenever the clients requests to get a specific statement.
  #
  # @see http://mcavage.me/node-restify/#Routing restify for detailed parameter description
  #
  show: (req, res, next) ->
    s = Statement.find req.params.id, (statement) =>
      res.body = JSON.stringify statement.map
      @send res, 501

  _prepareResponse: (res) ->
    super res
    res.header 'X-Experience-API-Consistent-Through', new Date(new Date() - 1000*60*60).toISOString()

