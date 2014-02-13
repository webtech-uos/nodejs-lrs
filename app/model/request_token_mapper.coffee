logger = require '../logger'
BaseMapper = require './base_mapper'

# Provides operations for all request tokens on top of CouchDB.
#
module.exports = class RequestTokenMapper extends BaseMapper

  @TYPE = 'request_token'

  @VIEWS =
    find_by_token:
      map: (doc)->
        if doc.type == 'request_token'
          emit doc.value.token, doc.value
        else
          emit null, null

  # Instanciates a new request token mapper.
  #
  # @param dbController
  #  the database-controller to be used by this mapper
  #
  constructor: (dbController, callback) ->
    addRequestTokens = () =>
      tokens = [
        {
          token: '8xme6vEQ'
          secret: '3D2fAxOFipvrHIBWiZLBR8moAYKRTxp0'
          userID: '0acaf301-f3e0-4a54-ad7a-9f6dbd9f6fdb'
          clientID: '31e9245c-85e8-422b-a85a-8af2c50905ea'
          approved: false
        }
      ]

      counter = 0
      for token in tokens
        @save token, (err) ->
          if err
            callback err
          else
            counter++
            if counter == tokens.length
              callback()

    super dbController, addRequestTokens

  # Returns the client with the given consumer key to the callback.
  #
  # @param consumerKey
  #   consumer key to search for
  #
  findByToken: (token, callback) ->
    @views.find_by_token key: token, (err, docs) =>
      if err
        logger.error 'find request token for token: '+token
        logger.error "database access with view request_token/find_by_token failed: #{JSON.stringify err}"
        callback err, []
      else
        if docs.length == 0
          logger.error "request token for token #{token} does not exist"
          err = new Error "Invalid request token: #{token}"
          err.httpCode = 400
          callback err
        else
          callback undefined, docs[0].value, docs[0].id

  # Approves an existing token.
  #
  # @param token
  #  the token to approve
  # @param userID
  #  the id of the user approving the token
  # @param verifier
  #  an optional verifier
  # @param callback
  #  called as soon as the token is approved
  #
  approve: (token, userID, verifier, callback) ->
    @findByToken token, (err, requestToken, id) =>
      if err
        callback err
      else
        requestToken.verifier = verifier
        requestToken.approved = true

        @update id, requestToken, (err) ->
          if err
            callback err
          else
            callback()

  # Stores a request token in the database
  #
  save: (requestToken, callback) ->
    super requestToken, (err, res) =>
      callback err, requestToken

  # Stores a request token in the database, updates its field if it already
  # exists.
  #
  update: (id, requestToken, callback) ->
    super id, requestToken, (err, res) =>
      callback err, requestToken
