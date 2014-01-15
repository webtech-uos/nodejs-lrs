passport = require 'passport'
login = require 'connect-ensure-login'

module.exports = 

  loginForm: (req, res) ->
    res.render 'login'

  login: passport.authenticate('local',
    successReturnToOrRedirect: '/account'
    failureRedirect: '/login'
  )
  
  logout: (req, res) ->
    req.logout()
    res.redirect '/login'

  account: [
    login.ensureLoggedIn()
    (req, res) ->
      res.render 'account', { user: req.user }
  ]