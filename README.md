# Overview
This project aims to implement a [Learning Record Store](https://en.wikipedia.org/wiki/Learning_Record_Store) based on the specifications of the RESTful [Experience API](http://www.adlnet.gov/tla/experience-api) ([API Spec](https://github.com/adlnet/xAPI-Spec/blob/1.0.0/xAPI.md)) in [node.js](http://nodejs.org/).

[![Build Status](https://travis-ci.org/webtech-uos/nodejs-lrs.png)](https://travis-ci.org/webtech-uos/nodejs-lrs)
[![Dependency Status](https://gemnasium.com/webtech-uos/nodejs-lrs.png)](https://gemnasium.com/webtech-uos/nodejs-lrs)

Documentation is generated using [Codo](https://github.com/coffeedoc/codo).
The current Docs can be found [here](http://coffeedoc.info/github/webtech-uos/nodejs-lrs).

A [report viewer](https://github.com/jvogtherr/ExperienceReportViewer) is beeing developed as part of this implementation.

# File Structure
 * `app` everything required during runtime
   * `controllers` controllers for each route
   * `validator` used to validate incoming JSON
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
* `grunt mochaTest` for running all test cases
* `grunt doc` to generate the latest docs locally in the `doc` folder

# DB
* install `couchDB`, see [here](http://couchdb.apache.org/)
* run `coffee app/database/init/db_init.coffee` inside the main-folder. This action will create a DB named "wt2" and fill it with sample data and views.
* results of the views:
  * views of the view group find by:
    * find documents by UUID. Example: find documents with UUID-mailbox "mailto:happy@happyplace.com". [link](http://localhost:5984/wt2/_design/find_by/_view/uuid?key="mailto:happy@happyplace.com")
    * find documents by verb TODO make TinCanAPI conform.
    * find documents by timestamp. Example: find documents with timestamp "2013-12-02T06:43:28.922Z". [link](http://localhost:5984/wt2/_design/find_by/_view/timestamp?key=%222013-12-02T06:43:28.922Z%22)
    * find documents by stored date. Example: find documents with stored date "2013-12-02T06:41:05.344Z". [link](http://localhost:5984/wt2/_design/find_by/_view/stored?key=%222013-12-02T06:41:05.344Z%22)
    * find documents by activity ID. Example: find the document with activity ID "8d9aa781-8790-46f2-b9f8-9564ac95548d". [link](http://localhost:5984/wt2/_design/find_by/_view/activity_id?key=%2228086d9c-2292-402a-9d17-0b3a5d0e6832%22)
    * You can use startkey, endkey and some other parameters. See more infos [here](http://guide.couchdb.org/index.html)
  * views of the view group counter:
    * number of all documents stored in the db: [link](http://localhost:5984/wt2/_design/counter/_view/all_docs)
    * number of documents stored at one day. Example: number of documents, created at "2013-12-02" [link](http://localhost:5984/wt2/_design/counter/_view/docs_per_day?key=%222013-12-02%22)

# Rules

* Code-Style: https://github.com/polarmobile/coffeescript-style-guide


## Vim Configuration
* a useful [vim script](http://www.vim.org/scripts/script.php?script_id=3590) that adds syntax highlighting, indentation and compilation support for Coffeescript.
Installation is explained on the site, but [pathogen](http://www.vim.org/scripts/script.php?script_id=2332) users can just clone this [URL](https://github.com/kchmck/vim-coffee-script.git) into their bundle directory.
* to conform to our [style guide](https://github.com/polarmobile/coffeescript-style-guide#whitespace), use these settings in your `.vimrc`, perhaps only for files with `.coffee` extension:

`    set expandtab`

`    set tabstop=2`
