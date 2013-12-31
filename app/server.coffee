restify = require 'restify'
routes = require './routes.coffee'

# Main class for launching the server.
# Only instanciate me once.
#
# TODO: Instanciate database
#
module.exports = class Server

  # Should only be called once.
  # Launches the learning record store.
  #
  # @param port
  #   number if server should listen on the supplied port
  #   false if server should not listen at all (for testing purposes)
  constructor: (port = 8080) ->
    @restServer = restify.createServer()
    @_registerRoutes()
    @restServer.listen(port) if port

  # Used to register all routes contained in the file `routes.coffee`. 
  #
  # @private
  #
  _registerRoutes: ->
    for url, route of routes
      for method, callback of route
        [controllerName, methodName] = callback.split '#'
        controller = new (require "./controllers/#{controllerName}")
        @restServer[method] url, do (controller, methodName) -> 
          (params...) -> controller[methodName].apply(controller, params)
    
  # For getting the required server object when running supertest.
  #
  _getRestifyServer: ->
    @restServer