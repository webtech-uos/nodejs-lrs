users = [
  { id: 1, password: 'pizza', name: 'bob' },
  { id: 2, password: 'cats', name: 'henry' }
]

module.exports =
  find: (id, done) ->
    done null, users[id]

  findByName: (name, done) ->
    result = null
    for user in users
      if user.name is name
        result = user
        break
    done null, result 
        
