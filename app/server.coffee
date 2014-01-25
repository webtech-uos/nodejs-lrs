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

    @express.get '/OAuth/authorize', oauth.userAuthorization
    @express.post '/OAuth/authorize', oauth.userDecision
    @express.post '/OAuth/initiate', oauth.requestToken
    @express.post '/OAuth/token', oauth.accessToken

    @dbController = new DBController config.database, (dbErr) =>
      if dbErr
        callback dbErr
      else
        @_createControllers (createErr) =>
          if createErr
            callback createErr
          else
            @_registerRoutes @controllers, (registerErr) =>
              if registerErr
                callback registerErr
              else if config.server.port
                @express.listen config.server.port, (listenErr) =>
                  if listenErr
                    callback listenErr, @
                  else
                    logger.info "server is listening on port #{config.server.port}..."
                    callback undefined, @
              else
                callback undefined, @

  _createControllers: (callback) ->
    logger.info "creat controllers:"
    @controllers = {}

    for url, route of routes
      for method, methodCallback of route
        [controllerName, methodName] = methodCallback.split '#'
        @controllers[controllerName] ?= {}
        @controllers[controllerName]['route'] ?= []
        routeInfo =
          url: "/api/#{url}"
          method: method
          methodName: methodName
        @controllers[controllerName]['route'].push routeInfo

    counter = 0
    size = Object.keys(@controllers).length
    dbCon = @dbController

    for name, dict of @controllers
      logger.info name
      do(name, dict, dbCon, callback) ->
        dict['object'] = new (require "./controllers/#{name}") dbCon, (err) =>
          if err
            logger.error err
            callback(err)
          else
            logger.info "controller '#{name}' has been created"
            counter++
            if counter == size
              callback()

  # Used to register all routes contained in the file `routes.coffee`.
  #
  # @private
  #
  _registerRoutes: (controllers, callback) ->
    logger.info "registering API routes:"

    for name, dict of controllers
      controller = dict['object']
      logger.info "registering API endpoints for route: '#{name}':"

      for endpoint in dict['route']
        methodName = endpoint.methodName
        logger.info "connect method: '#{endpoint.method}' to url: '#{endpoint.url}' and the method:'#{endpoint.methodName}'."

        @express[endpoint.method] endpoint.url, passport.authenticate 'token', { session: false } if config.server.oauth
        @express[endpoint.method] endpoint.url, controller.before
        @express[endpoint.method] endpoint.url, do (controller, methodName) ->
          methods = controller[methodName]
          (params...) => controller[methodName].apply(controller, params)

    callback()


  # For getting the required server object when running supertest.
  #
  getRestServer: ->
    @express

  # For getting the required database controller when running supertest.
  #
  getDBController: ->
    @dbController
