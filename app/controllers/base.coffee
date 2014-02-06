semver = require 'semver'
serverConfig = require('../config').server

# Base class for all conttrollers.
#
module.exports = class BaseController

  constructor: (@dbController, callback) ->
    logger.warn "no callback supplied for new controller" unless callback
    callback()
    
  # Executed before each controller action.
  #
  before: (req, res, next) ->
    res.header 'Content-Type', 'application/json'
    res.header 'x-experience-api-version', serverConfig.xApiVersion

    # validate version
    reqVersion = req.get('x-experience-api-version')
    if reqVersion and reqVersion isnt '1.0'
      if semver.valid reqVersion
        if semver.satisfies reqVersion, serverConfig.xApiVesionRange
          next()
        else
        res.send 400, "Currently only #{serverConfig.xApiVersionRange} is supported."
      else
        res.send 400, "Invalid API version specified. Please refer to semver versioning."
    else
      next()
