# Overview
This project aims to implement a [Learning Record Store](https://en.wikipedia.org/wiki/Learning_Record_Store) based on the specifications of the RESTful [Experience API](http://www.adlnet.gov/tla/experience-api) in [node.js](http://nodejs.org/).

[![Build Status](https://travis-ci.org/webtech-uos/nodejs-lrs.png)](https://travis-ci.org/webtech-uos/nodejs-lrs)


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
* Install `node`, see `package.json` for required version
* run `npm install -g grunt-cli` if you want to use grunt (highly recommend!)
* run `npm install` to install all dependencies locally
* hit `grunt` to launch the application
* `grunt test` for running all test cases
