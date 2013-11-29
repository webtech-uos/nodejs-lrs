restify = require 'restify'
routes = require './routes.coffee'

server = restify.createServer()

for url, route of routes
  for method, callback of route
    [controllerName, methodName] = callback.split '#'
    controller = require "./controllers/#{controllerName}"
    server[method] url, controller[methodName]

server.listen 80