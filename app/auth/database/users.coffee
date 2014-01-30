users = [
  { id: 0, password: 'pizza', name: 'bob' },
  { id: 1, password: 'cats', name: 'henry' }
]

logger = require '../../logger'

module.exports =
  find: (id, done) ->
    done null, users[id]

  findByName: (name, done) ->
    result = null
    for user in @getAll()
      if user.name is name
        result = user
        break
    done null, result

  remove: (userName, done) ->
    @findByName userName, (dummy, user) ->
      if user
        #TODO: add DB remove here
        logger.info "Removing user '#{userName}'"
      else
        logger.info "User not found [#{userName}]"
      done() if done
    return

  add: (userName, password, done) ->
    #TODO: add DB insert here
    logger.info "Adding user '#{userName}, #{password}'"
    done() if done
    return

  removeAll: ->
    _users = @getAll()
    for user in _users
      @remove(user.name)
    return

  addFromFile: (fileName, done) ->
    fs = require('fs')
    data = fs.readFileSync(fileName, "utf8")
    _users = data.split("\r\n")
    for user in _users
      split = user.split(" ")
      @tryAdd(split[0], split[1])
    return

  tryAdd: (userName, password) ->
    exists = false
    if userName && password && !exists
      @add(userName, password)
      return true
    logger.warn "Failed to add user '#{userName}, #{password}'"
    return false

  getAll: ->
    return users

  getList: (done) ->
    _users = @getAll()
    result = []
    for user in _users
      result.push { id: user.id, name: user.name }
    done(result)