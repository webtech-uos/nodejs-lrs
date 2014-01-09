module.exports = (grunt) ->

  grunt.loadNpmTasks 'grunt-mocha-test'
  grunt.loadNpmTasks 'grunt-nodemon'

  grunt.initConfig
    pkg: grunt.file.readJSON 'package.json'

    mochaTest:
      unit:
        options:
          reporter: 'nyan'
        src: ['test/unit/**/*.coffee']
      functional:
        options:
          reporter: 'nyan'
        src: ['test/functional/**/*.coffee']
      integration:
        options:
          reporter: 'nyan'
        src: ['test/integration/**/*.coffee']

    nodemon:
      dev:
        options:
          file: 'app/main.coffee'

  grunt.registerTask 'default', 'Launch the server using nodemon', ['nodemon']

  grunt.registerTask 'doc', 'Generate codo documentation', ->
    require 'codo/lib/codo'
    cmd = require 'codo/lib/command'
    cmd.run()
