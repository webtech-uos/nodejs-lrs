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
          approved: true
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
          logger.info "request token for token #{token} does not exist"
          callback undefined
        else
          callback undefined, docs[0].value

  # Stores a request token in the database
  #
  save: (requestToken, callback) ->
    super requestToken, (err, res) =>
      callback err, requestToken
