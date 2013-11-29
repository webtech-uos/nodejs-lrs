module.exports = (grunt) ->
    
  grunt.loadNpmTasks 'grunt-mocha-test'
  grunt.loadNpmTasks 'grunt-nodemon'
  
  
  grunt.initConfig
    pkg: grunt.file.readJSON 'package.json'
    
    mochaTest:
      test:
        options:
          reporter: 'spec'
        src: ['test/**/*.coffee']
        
    nodemon:
      dev:
        options:
          file: 'app/main.coffee'
    
  grunt.registerTask 'default', ['nodemon']
    
  grunt.registerTask 'test', ['mochaTest']