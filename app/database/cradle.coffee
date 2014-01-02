module.exports = class Cradle

	instance = null

	class PrivateCradle
		cradle = require 'cradle'
		
		statements = null

		constructor: (host) ->
			console.log "Initiiere DB"
			cradle.setup {host: host}

			conn = new(cradle.Connection)

			statements = conn.database('statements')
			statements.create()

		about: ->
			console.log conn

		statements: ->
			return statements

	@get: (host) ->
		instance ?= new PrivateCradle(host)