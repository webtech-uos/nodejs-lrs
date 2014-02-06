logger = require '../logger'
utils = require '../utils'
BaseMapper = require './base_mapper'

# Provides operations for all clients on top
# of CouchDB.
#
module.exports = class ClientMapper extends BaseMapper

  @TYPE = 'client'

  @VIEWS =
    find_by_id:
      map: (doc)->
        if doc.type == 'client'
          emit doc.value.id, doc.value
        else
          emit null, null
    find_by_consumer_key:
      map: (doc)->
        if doc.type == 'client'
          emit doc.value.consumerKey, doc.value
        else
          emit null, null

  # Instanciates a new client mapper.
  #
  # @param dbController
  #  the database-controller to be used by this mapper
  #
  constructor: (dbController, callback) ->
    addClients = () =>
      clients = [
        {
          name: 'Samplr'
          consumerKey: 'abc123'
          consumerSecret: 'ssh-secret'
        }
      ]

      counter = 0
      for client in clients
        @save client, (err) ->
          if err
            callback err
          else
            counter++
            if counter == clients.length
              callback()

    super dbController, addClients

  # Returns the client with the given id to the callback.
  #
  # @param id
  #   id of the client to look up
  #
  find: (id, callback) ->
    @views.find_by_id key: id, (err, docs) =>
      if err
        logger.error 'find client: ' + id
        logger.error "find: database access with view find_client_by/id failed: #{JSON.stringify err}"
        callback err, []
      else
        if docs.length == 0
          logger.info 'client does not exist: ' + id
          callback undefined
        else
          callback undefined, docs[0].value

  # Returns the client with the given consumer key to the callback.
  #
  # @param consumerKey
  #   consumer key to search for
  #
  findByConsumerKey: (consumerKey, callback) ->
    @views.find_by_consumer_key key: consumerKey, (err, docs) =>
      if err
        logger.error 'find client with consumer key: '+consumerKey
        logger.error "find: database access with view client_find_by/consumer_key failed: #{JSON.stringify err}"
        callback err, []
      else
        if docs.length == 0
          logger.info "client for consumer key #{consumerKey} does not exist"
          callback undefined
        else
          callback undefined, docs[0].value

  # Writes a client to the database.
  #
  save: (client, callback) ->
    unless client.id
      # No id is given, generate one
      client.id = utils.generateUUID()

    @find client.id, (err, foundClient) =>
      if err
        logger.error 'find returned error: ' + err
        callback err
      else
        if foundClient
          callback null, foundClient
        else
          super client, (err, res) =>
            callback err, client
