semver = require 'semver'
version = require('../config').server.xApiVersion

# Base class for all conttrollers.
#
module.exports = class BaseController


  # Creates a new controller.
  #
  constructor: (@dbController) ->


  # Executed before each controller action.
  #
  before: (req, res, next) ->
    res.header 'Content-Type', 'application/json'
    res.header 'x-experience-api-version', version
    
    # validate version
    reqVersion = req.get('x-experience-api-version')
    if reqVersion and reqVersion isnt '1.0'
      if semver.valid reqVersion
        if semver.eq reqVersion, version
          next()
        else
        res.send 400, "Currently only #{version} is supported."
      else
        res.send 400, "Invalid API version. Please refer to semver versioning."
    else
      next()