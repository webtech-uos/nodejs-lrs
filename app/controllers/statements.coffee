BaseController = require './base'
StatementMapper = require '../model/statement_mapper'
logger = require '../logger'

# Controller for route `statements`.
#
module.exports = class StatementsController extends BaseController

  constructor: (@dbController, callback) ->
    logger.warn "no callback supplied for new statements-controller" unless callback
    dbCon = @dbController
    super(dbCon, (err) =>
      if err
        callback err
      else
        @mapper = new StatementMapper dbCon, callback
    )

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
      mapper = @mapper
      do(mapper, statement) ->
        mapper.save statement, (err, createdStatement) =>
          if err
            logger.error err
            errors[statement] = err
            status = err.httpCode ? 500
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
    badParam = false

    for k of req.query
      unless k in ['statementId', 'voidedStatementId', 'agent', 'verb', 'activity', 'registration', 'related_activities', 'since', 'until', 'limit', 'format', 'attachments', 'ascending']      
      #unless k in ['statementId', 'attachments', 'format', 'voidedStatementId','agent']
        badParam = k
        break

    if badParam
      res.json 400, "Query parameter \"#{badParam}\" not allowed here."
    else
      id = req.query.statementId
      agent = req.query.agent
      if id
        @_sendStatement id, res
      else if agent
        @_agent res, agent
      else
        options =
          skip: 0
        @mapper.getAll options, (err, statements, optionsOut) =>
          res.json 200, statements

  # Called whenever the clients requests to modify a specific statement.
  #
  # @see http://mcavage.me/node-restify/#Routing restify for detailed parameter description
  #
  update: (req, res, next) ->
    @mapper.save req.body, (err, statement) =>
      res.json err?.httpCode ? 204, err

  # Called whenever the clients requests to get a specific statement.
  #
  # @see http://mcavage.me/node-restify/#Routing restify for detailed parameter description
  #
  # show: (req, res, next) ->
    # @_sendStatement req.params.id, res

  # Sends a specific statement.
  #
  # @private
  #
  _sendStatement: (id, res) ->
    @mapper.find id, (err, statement) =>
      if err
        res.json err.httpCode ? 500, err
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

  # Gets all statements of an agent
  #
  _agent: (res, agent) ->
    @mapper.findByAgent agent, (err, statements) =>
      if err
        res.json err.httpCode ? 500, err
      else
        if statements
          res.json 200, statements
        else
          res.json 404, "No agent with name #{agent} found!"
