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
        src: ['test/functional/statements/**/*.coffee']
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
    
  grunt.registerTask 'list_users', ->
    users = require './app/auth/database/users'
    users.list()

  grunt.registerTask 'add_user', ->
    users = require './app/auth/database/users'
    users.tryAdd(grunt.option('name'), grunt.option('pw'))

  grunt.registerTask 'add_users', ->
    users = require './app/auth/database/users'
    users.addFromFile(grunt.option('file'))

  grunt.registerTask 'remove_users', ->
    users = require './app/auth/database/users'
    users.removeAll()

  grunt.registerTask 'remove_user', ->
    users = require './app/auth/database/users'
    users.remove(grunt.option('name'))

  grunt.registerTask 'users_man', ->
    console.log("add_user [-name] [-pw]")
    console.log("add_users [-file]")
    console.log("remove_user [-name]")
    console.log("remove_users")
    console.log("list_users")
