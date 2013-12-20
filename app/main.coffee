restify = require 'restify'
routes = require './routes.coffee'

# Main class for launching the application.
# Only instanciate me once.
#
class Main

  # Should only be called once.
  # Launches the learning record store.
  #
  constructor: ->
    @server = restify.createServer()
    @_registerRoutes()
    @_start()

  # Used to register all routes contained in the file `routes.coffee`. 
  #
  # @private
  #
  _registerRoutes: ->
    for url, route of routes
      for method, callback of route
        [controllerName, methodName] = callback.split '#'
        controller = require "./controllers/#{controllerName}"
        @server[method] url, do (controller, methodName) -> 
          (params...) -> controller[methodName].apply(controller, params)

  # Used to start the server on port `8080`.
  #
  # @private
  #
  _start: ->
    @server.listen 8080

main = new Main

# FIXME: find a better way to expose the http server object for testing
# (this is used now in test/node_modules/setup_server.coffee)
module.exports = Main
