Controller = require './base.coffee'

class StatementController extends Controller
  
  create: (req, res, next) ->
    res.send 501
  
  index: (req, res, next) ->
    res.send 501
  
  update: (req, res, next) ->
    res.send 501
  
  show: (req, res, next) ->
    res.send 501

module.exports = new StatementController