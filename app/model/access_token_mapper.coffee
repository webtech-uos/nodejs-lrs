logger = require '../logger'
BaseMapper = require './base_mapper'

# Provides operations for all access tokens on top of CouchDB.
#
module.exports = class AccessTokenMapper extends BaseMapper

  @TYPE = 'access_token'

  @VIEWS = {}

  # Instanciates a new access token mapper.
  #
  # @param dbController
  #  the database-controller to be used by this mapper
  #
  constructor: (@dbController, callback) ->
    super

  # Stores an access token in the database
  #
  save: (accessToken, callback) ->
    super accessToken, (err, res) =>
      callback err, accessToken
