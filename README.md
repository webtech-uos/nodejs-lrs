# Overview
This project aims to implement a [Learning Record Store](https://en.wikipedia.org/wiki/Learning_Record_Store) based on the specifications of the RESTful [Experience API](http://www.adlnet.gov/tla/experience-api) ([API Spec](https://github.com/adlnet/xAPI-Spec/blob/1.0.0/xAPI.md)) in [node.js](http://nodejs.org/).

[![Build Status](https://travis-ci.org/webtech-uos/nodejs-lrs.png)](https://travis-ci.org/webtech-uos/nodejs-lrs)
[![Dependency Status](https://gemnasium.com/webtech-uos/nodejs-lrs.png)](https://gemnasium.com/webtech-uos/nodejs-lrs)

Documentation is generated using [Codo](https://github.com/coffeedoc/codo).
The current Docs can be found [here](http://coffeedoc.info/github/webtech-uos/nodejs-lrs).

A [report viewer](https://github.com/jvogtherr/ExperienceReportViewer) is beeing developed as part of this implementation.

# Deployment
* edit `app/config.coffee` to match your `couchDB` server
* install `node`, see `package.json` for required version
* install all global dependencies or add the projects `node_modules/.bin` to your `PATH`. This only needs to be done in development mode. Currently the global dependencies are:
  * `grunt-cli`
  * `coffee-script` (won't be needed as soon as [this issue](https://github.com/remy/nodemon/issues/210) is resolved)
* run `npm install` to install all dependencies locally
* hit `grunt` to launch the application
* `grunt mochaTest` for running all test cases
* `grunt doc` to generate the latest docs locally in the `doc` folder
