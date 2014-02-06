module.exports = (grunt) ->

  grunt.loadNpmTasks 'grunt-mocha-test'
  grunt.loadNpmTasks 'grunt-nodemon'

  rep = if process.env.TRAVIS? then 'spec' else 'dot'

  grunt.initConfig
    mochaTest:
      unit:
        options:
          reporter: rep
        src: ['test/unit/**/*.coffee']
      functional:
        options:
          reporter: rep
        src: ['test/functional/statements/get/test.coffee']
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
    
  grunt.registerTask 'users', ['users:list']

  grunt.registerTask 'users:list', ->
    users = require './app/auth/database/users'
    users.getList (users) ->
      for user in users
        grunt.log.writeln "#{user.id}\t#{user.name}"

  grunt.registerTask 'users:add', ->
    users = require './app/auth/database/users'
    if grunt.option('name')
      users.tryAdd(grunt.option('name'), grunt.option('pw'))
    if grunt.option('file')
      users.addFromFile(grunt.option('file'))

  grunt.registerTask 'users:remove', ->
    users = require './app/auth/database/users'
    if grunt.option('name')
      users.remove(grunt.option('name'))
    else if grunt.option('all')
      users.removeAll()

  grunt.registerTask 'users:help', ->
    grunt.log.writeln 'users:add [-name] [-pw] [-file]'
    grunt.log.writeln 'users:remove [-name]'
    grunt.log.writeln 'users:list'
