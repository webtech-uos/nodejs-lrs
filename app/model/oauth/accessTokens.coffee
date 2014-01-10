tokens = {}

module.exports =
  find: (key, done) ->
    token = tokens[key]
    return done(null, token)

  save: (token, secret, userID, clientID, done) ->
    tokens[token] = { secret: secret, userID: userID, clientID: clientID }
    return done(null)
