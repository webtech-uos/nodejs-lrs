clients = [
  { id: '1', name: 'Samplr', consumerKey: 'abc123', consumerSecret: 'ssh-secret' }
]

module.exports =
  find: (id, done) ->
    for client in clients
      if client.id == id
        return done(null, client)

    return done(null, null)

  findByConsumerKey: (consumerKey, done) ->
    for client in clients
      if client.consumerKey == consumerKey
        return done(null, client)

    return done(null, null)