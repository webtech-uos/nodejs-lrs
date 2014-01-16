express = require 'express'
passport = require 'passport'
config = require './config'
routes = require './routes'
DBController = require './model/database/db_controller'
logger = require './logger'

# Main class for launching the server.
# Only instanciate me once.
#
module.exports = class Server

  # Should only be called once.
  # Launches the learning record store.
  #
  # @param config
  #   the configuration object, for details
  #   take a look at `config.coffee`
  #
  # @param callback
  #   Will be called as soon as the server is started
  #   or an error occured (first parameter).
  #   If no error occured one can assume a valid database
  #   connection and listening HTTP server.
  #
  constructor: (config, callback = ->) ->
    logger.info "Let the magic happen."

    @express = express()
    @express.set 'view engine', 'ejs'
    @express.set 'views', './app/auth/views'
    @express.use express.logger stream:
      write: (message) -> logger.info message

    @express.use express.cookieParser()
    # bodyParser is still required for passport
    # hopefully getting fixed soon
    # @express.use express.urlencoded()
    # @express.use express.json()
    @express.use express.bodyParser()

    # FIXME: Not exactly a secret
    @express.use express.session { secret: 'keyboard cat' }

    @express.use passport.initialize()
    @express.use passport.session()
    @express.use @express.router
    @express.use express.errorHandler
      dumpExceptions: true
      showStack: true

    require './auth/strategies'
    user = require './auth/user'
    oauth = require './auth/oauth'

    @express.get '/login', user.loginForm
    @express.post '/login', user.login
    @express.get '/logout', user.logout
    @express.get '/account', user.account

    @express.get '/dialog/authorize', oauth.userAuthorization
    @express.post '/dialog/authorize/decision', oauth.userDecision
    @express.post '/oauth/request_token', oauth.requestToken
    @express.post '/oauth/access_token', oauth.accessToken

    @dbController = new DBController config.database, (err) =>
      if err
        callback err
      else
        if config.server.port
          @express.listen config.server.port, (err) =>
            logger.info 'server listening'
            callback err, @
        else
          callback undefined, @
    @_registerRoutes()

  # Used to register all routes contained in the file `routes.coffee`.
  #
  # @private
  #
  _registerRoutes: ->
    controllers = {}
    for url, route of routes
      url = "/api/#{url}"
      for method, callback of route
        [controllerName, methodName] = callback.split '#'
        controller = controllers[controllerName] ?= new (require "./controllers/#{controllerName}") @dbController
        logger.info "registering API route '#{method} #{url}'"
        @express[method] url, passport.authenticate 'token', { session: false } if config.server.oauth
        @express[method] url, do (controller, methodName) ->
          methods = controller[methodName]
          (params...) -> controller[methodName].apply(controller, params)

  # For getting the required server object when running supertest.
  #
  getRestServer: ->
    @express

  # For getting the required database controller when running supertest.
  #
  getDBController: ->
    @dbController
