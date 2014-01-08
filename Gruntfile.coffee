module.exports = (grunt) ->

  grunt.loadNpmTasks 'grunt-mocha-test'
  grunt.loadNpmTasks 'grunt-nodemon'

  grunt.initConfig
    pkg: grunt.file.readJSON 'package.json'

    mochaTest:
      test:
        options:
          reporter: 'nyan'
          require: ['coffee-script']
        src: ['test/**/*.coffee']
      "unit-validator":
        options:
          reporter: 'nyan'
        src: ['test/unit/validator/**/*.coffee']
      "api":
        options:
          reporter: 'nyan'
        src: ['test/functional/**/*.coffee']

    nodemon:
      dev:
        options:
          file: 'app/main.coffee'

  grunt.registerTask 'default', 'Launch the server using nodemon', ['nodemon']

  grunt.registerTask 'test', 'Run the whole test suite', ['mochaTest']

  grunt.registerTask 'doc', 'Generate codo documentation', ->
    require 'codo/lib/codo'
    cmd = require 'codo/lib/command'
    cmd.run()

  grunt.registerTask 'init', 'Initialise the database', ->
    "TODO"
#   initDb = require './app/database/init/db_init.coffee'
#   new initDb
