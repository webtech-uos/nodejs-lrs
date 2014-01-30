users = [
  { id: 0, password: 'pizza', name: 'bob' },
  { id: 1, password: 'cats', name: 'henry' }
]

printf = console.log

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
        printf("Removing user '#{userName}'")
      else
        printf("User not found [#{userName}]")
      done() if done
    return

  add: (userName, password, done) ->
    #TODO: add DB insert here
    printf("Adding user '#{userName}, #{password}'")
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
    printf("Failed to add user '#{userName}, #{password}'")
    return false

  getAll: ->
    return users

  list: (printer, done) ->
    _users = @getAll()
    for user in _users
      printer(user) if printer or printf(user)
    done() if done
    return