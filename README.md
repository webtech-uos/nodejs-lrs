# Overview
This project aims to implement a [Learning Record Store](https://en.wikipedia.org/wiki/Learning_Record_Store) based on the specifications of the RESTful [Experience API](http://www.adlnet.gov/tla/experience-api) in [node.js](http://nodejs.org/).

[![Build Status](https://travis-ci.org/webtech-uos/nodejs-lrs.png)](https://travis-ci.org/webtech-uos/nodejs-lrs)
[![Dependency Status](https://gemnasium.com/webtech-uos/nodejs-lrs.png)](https://gemnasium.com/webtech-uos/nodejs-lrs)

Documentation is generated using [Codo](https://github.com/coffeedoc/codo).
The current Docs can be found [here](http://coffeedoc.info/github/webtech-uos/nodejs-lrs).

A [report viewer](https://github.com/jvogtherr/ExperienceReportViewer) is beeing developed as part of this implementation.

# File Structure
 * `app` everything required during runtime
   * `controllers` controllers for each route
   * `model` database abstraction layer
 * `test` all test cases
   * `unit` simple unit tests
   * `functional` test for single controller actions
   * `integration` testing the whole system, typically multiple controller actions
   * `data` experience api test suite

# Deployment
* install `node`, see `package.json` for required version
* install all global dependencies or add the projects `node_modules/.bin` to your `PATH`. This only needs to be done in development mode. Currently the global dependencies are:
  * `grunt-cli`
  * `coffee-script` (won't be needed as soon as [this issue](https://github.com/remy/nodemon/issues/210) is resolved)
* run `npm install` to install all dependencies locally
* hit `grunt` to launch the application
* `grunt test` for running all test cases
* `grunt doc` to generate the latest docs locally in the `doc` folder

# DB
* install `couchDB`, see [here](http://couchdb.apache.org/)
* run `coffee app/database/init/db_init.coffee` inside the main-folder. This action will create a DB named "wt2" and fill it with sample data and views.
* results of the views:
  * views of the view group find by:
    * find documents by UUID. 

      Example: find documents with UUID-mailbox "mailto:happy@happyplace.com". [http://localhost:5984/wt2/_design/find_by/_view/uuid?key="mailto:happy@happyplace.com"](http://localhost:5984/wt2/_design/find_by/_view/uuid?key="mailto:happy@happyplace.com")
    * find documents by verb TODO make TinCanAPI conform.
    * find documents by timestamp. Example: find documents with timestamp "2013-12-02T06:43:28.922Z". [http://localhost:5984/wt2/_design/find_by/_view/timestamp?key="2013-12-02T06:43:28.922Z"](http://localhost:5984/wt2/_design/find_by/_view/timestamp?key=%222013-12-02T06:43:28.922Z%22)
    * find documents by stored date. Example: find documents with stored date "2013-12-02T06:41:05.344Z". [http://localhost:5984/wt2/_design/find_by/_view/stored?key="2013-12-02T06:41:05.344Z"](http://localhost:5984/wt2/_design/find_by/_view/stored?key=%222013-12-02T06:41:05.344Z%22)
    * 







[http://localhost:5984/wt2/_design/find_by/_view/email](http://localhost:5984/wt2/_design/find_by/_view/email)

[http://localhost:5984/wt2/_design/find_by/_view/activity_id](http://localhost:5984/wt2/_design/find_by/_view/activity_id)

[http://localhost:5984/wt2/_design/find_by/_view/verb](http://localhost:5984/wt2/_design/find_by/_view/verb)

[http://localhost:5984/wt2/_design/find_by/_view/stored](http://localhost:5984/wt2/_design/find_by/_view/stored)

[http://localhost:5984/wt2/_design/find_by/_view/timestamp](http://localhost:5984/wt2/_design/find_by/_view/timestamp)

Find statements by email (test@test.com):
[http://localhost:5984/wt2/__design/find__by/_view/email?key="mailto:test@test.com"](http://localhost:5984/wt2/_design/find_by/_view/email?key=%22mailto:test@test.com%22)

Find statements by activity id (http://www.example.com):
[http://localhost:5984/wt2/__design/find__by/_view/activity_id?key="http://www.example.com"](http://localhost:5984/wt2/_design/find_by/_view/activity_id?key=%22http://www.example.com%22)
