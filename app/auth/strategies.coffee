passport = require 'passport'
LocalStrategy = require('passport-local').Strategy
ConsumerStrategy = require('passport-http-oauth').ConsumerStrategy
TokenStrategy = require('passport-http-oauth').TokenStrategy
users = require './database/users'
requestTokens = require './database/request_tokens'
accessTokens = require './database/access_tokens'

module.exports = class Strategies
  constructor: (accessTokenMapper, clientMapper, requestTokenMapper, userMapper) ->

    # This strategy is used to authenticate users based on a username and password.
    # Anytime a request is made to authorize an application, we must ensure that
    # a user is logged in before asking them to approve the request.
    #
    passport.use new LocalStrategy (username, password, done) ->
      users.findByName username, (err, user) ->
        console.log user
        if err
          done err
        else
          done null, if user?.password is password then user else null

    passport.serializeUser (user, done) ->
      done null, user.id

    passport.deserializeUser (id, done) ->
      users.find id, done


    # This strategy is used to authenticate registered OAuth consumers (aka
    # clients).  It is employed to protect the `request_tokens` and `access_token`
    # endpoints, which consumers use to request temporary request tokens and access
    # tokens.
    #
    passport.use 'consumer', new ConsumerStrategy(

      #  This callback finds the registered client associated with `consumerKey`.
      #  The client should be supplied to the `done` callback as the second
      #  argument, and the consumer secret known by the server should be supplied
      #  as the third argument.  The `ConsumerStrategy` will use this secret to
      #  validate the request signature, failing authentication if it does not
      #  match.
      (consumerKey, done) ->
        clientMapper.findByConsumerKey consumerKey, (err, client) ->
          if err
            done err
          else
            done null, client, client?.consumerSecret

      # This callback finds the request token identified by `requestToken`.  This
      #  is typically only invoked when a client is exchanging a request token for
      # an access token.  The `done` callback accepts the corresponding token
      # secret as the second argument.  The `ConsumerStrategy` will use this secret to
      # validate the request signature, failing authentication if it does not
      # match.
      #
      # Furthermore, additional arbitrary `info` can be passed as the third
      # argument to the callback.  A request token will often have associated
      # details such as the user who approved it, scope of access, etc.  These
      # details can be retrieved from the database during this step.  They will
      # then be made available by Passport at `req.authInfo` and carried through to
      # other middleware and request handlers, avoiding the need to do additional
      # unnecessary queries to the database.
      (requestToken, done) ->
        requestTokens.find requestToken, (err, token) ->
          if err
            done err
          else
            done null, token.secret,
              verifier: token.verifier
              clientID: token.clientID
              userID: token.userID
              approved: token.approved

      # The application can check timestamps and nonces, as a precaution against
      # replay attacks.  In this example, no checking is done and everything is
      # accepted.
      (timestamp, nonce, done) ->
        done(null, true)
    )


    # This strategy is used to authenticate users based on an access token.  The
    # user must have previously authorized a client application, which is issued an
    # access token to make requests on behalf of the authorizing user.
    #
    passport.use 'token', new TokenStrategy(

      # This callback finds the registered client associated with `consumerKey`.
      # The client should be supplied to the `done` callback as the second
      # argument, and the consumer secret known by the server should be supplied
      # as the third argument.  The `TokenStrategy` will use this secret to
      # validate the request signature, failing authentication if it does not
      # match.
      (consumerKey, done) ->
        clients.find consumerKey, (err, client) ->
          if err
            done err
          else
            done null, client, client?.consumerSecret

      # This callback finds the user associated with `accessToken`.  The user
      # should be supplied to the `done` callback as the second argument, and the
      # token secret known by the server should be supplied as the third argument.
      # The `TokenStrategy` will use this secret to validate the request signature,
      # failing authentication if it does not match.
      #
      # Furthermore, additional arbitrary `info` can be passed as the fourth
      # argument to the callback.  An access token will often have associated
      # details such as scope of access, expiration date, etc.  These details can
      # be retrieved from the database during this step.  They will then be made
      # available by Passport at `req.authInfo` and carried through to other
      # middleware and request handlers, avoiding the need to do additional
      # unnecessary queries to the database.
      #
      # Note that additional access control (such as scope of access), is an
      # authorization step that is distinct and separate from authentication.
      # It is an application's responsibility to enforce access control as
      # necessary.
      (accessToken, done) ->
        accessTokens.find accessToken, (err, token) ->
          if err
            done err
          else
            users.find token.userID, (err, user) ->
              if err
                done err
              else
              if user
                # to keep this example simple, restricted scopes are not implemented
                done null, user, token.secret, { scope: '*' }
              else
                done null, false

      # The application can check timestamps and nonces, as a precaution against
      # replay attacks.  In this example, no checking is done and everything is
      # accepted.
      (timestamp, nonce, done) ->
        done(null, true)

    )
