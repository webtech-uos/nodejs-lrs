logger = require '../logger'
_ = require 'underscore'
utils = require '../utils'
BaseMapper = require './base_mapper'

# Provides operations for all users on top
# of CouchDB.
#
module.exports = class UserMapper extends BaseMapper

  @TYPE = 'user'

  @VIEWS =
    find_by_id:
      map: (doc)->
        if doc.type == 'user'
          emit doc.value.id, doc.value
        else
          emit null, null
    list:
      map: (doc)->
        if doc.type == 'user'
          emit doc._id, doc.value
        else
          emit null, null

  # Instanciates a new user mapper.
  #
  # @param dbController
  #  the database-controller to be used by this mapper
  #
  constructor: (dbController, callback) ->

    addUsers = () =>
      users = [
        {
          username: 'bob'
          password: 'pizza'
          id: '0acaf301-f3e0-4a54-ad7a-9f6dbd9f6fdb'
        }
        {
          username: 'henry'
          password: 'cats'
          id: '6894baa7-f7bd-42be-9c98-a3bc68c5640b'
        }
      ]

      counter = 0
      for user in users
        @save user, (err) ->
          if err
            callback err
          else
            counter++
            if counter == users.length
              callback()

    super dbController, addUsers

  # Returns all stored users to the callback.
  #
  getAll: (callback) ->
    @views.list (err, users) ->
      callback null, users

  # Returns the user with the given id to the callback.
  #
  # @param id
  #   id of the user to look up
  #
  find: (id, callback) ->
    @views.find_by_id key: id, (err, docs) =>
      if err
        logger.error 'find user: ' + id
        logger.error "find: database access with view find_user_by/id failed: #{JSON.stringify err}"
        callback err, []
      else
        if docs.length == 0
          logger.info 'user does not exist: ' + id
          callback undefined
        else
          callback undefined, docs[0].value

  # Saves a user to the database
  #
  save: (user, callback) ->
    unless user.id
      # No id is given, generate one
      user.id = utils.generateUUID()

    @find user.id, (err, foundUser) =>
      if err
        logger.error 'find returned error: ' + err
        callback err
      else
        if foundUser
          callback null, foundUser
        else
          super user, (err, res) =>
            callback err, user
