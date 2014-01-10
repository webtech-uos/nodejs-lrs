passport = require 'passport'
oauthorize = require 'oauthorize'
BaseController = require './base'
utils = require '../utils'
clients = require '../model/oauth/clients'
accessTokens = require '../model/oauth/accessTokens'
requestTokens = require '../model/oauth/requestTokens'

class OAuthController extends BaseController

  constructor: ->
    @oauthServer = oauthorize.createServer()

  request_token: (req, res, next) ->
    passport.authenticate 'consumer', { session: false }
    @oauthServer.requestToken (client, callbackURL, done) ->
      token = utils.uid 8
      secret = utils.uid 32

      requestTokens.save token, secret, client.id, callbackURL, (err) ->
        if err
          return done err
        return done null, token, secret

    @oauthServer.errorHandler()

  access_token: (req, res, next) ->
    passport.authenticate 'consumer', { session: false }
    @oauthServer.accessToken ->
      (requestToken, verifier, info, done) ->
        if verifier != info.verifier
          return done null, false
        return done null, true
      (client, requestToken, info, done) ->
        if !info.approved
          return done null, false
        if client.id != info.clientID
          return done null, false

        token = utils.uid 16
        secret = utils.uid 64

        accessTokens.save token, secret, info.userID, info.clientID, (err) ->
          if err
            return done err
          return done null, token, secret

    @oauthServer.errorHandler()

  authorize_token: (req, res, next) ->
    @oauthServer.userAuthorization (requestToken, done) ->
      requestTokens.find requestToken, (err, token) ->
        if err
          return done err
        clients.find token.clientID, (err, client) ->
          if err
            return done err
          return done null, client, token.callbackURL
    (req, res) ->
      res.render 'dialog', { transactionID: req.oauth.transactionID, user: req.user, client: req.oauth.client }

module.exports = OAuthController
