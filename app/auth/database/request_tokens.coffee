tokens = {}

module.exports =
  find: (key, done) ->
    token = tokens[key]
    return done(null, token)

  save: (token, secret, clientID, done) ->
    tokens[token] = { secret: secret, clientID: clientID }
    return done(null)

  approve: (key, userID, verifier, done) ->
    token = tokens[key]
    token.userID = userID
    token.verifier = verifier
    token.approved = true
    return done(null)
