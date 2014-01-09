module.exports = (grunt) ->

  grunt.loadNpmTasks 'grunt-mocha-test'
  grunt.loadNpmTasks 'grunt-nodemon'
  
  rep = if process.env.TRAVIS? then 'spec' else 'nyan'
  
  grunt.initConfig
    mochaTest:
      unit:
        options:
          reporter: rep
        src: ['test/unit/**/*.coffee']
      functional:
        options:
          reporter: rep
        src: ['test/functional/**/*.coffee']
      integration:
        options:
          reporter: rep
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
