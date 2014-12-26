# Generated on 2014-12-25 using generator-bower 0.0.1
'use strict'

mountFolder = (connect, dir) ->
    connect.static require('path').resolve(dir)

module.exports = (grunt) ->
  require('matchdep').filterDev('grunt-*').forEach(grunt.loadNpmTasks)

  yeomanConfig =
    src: 'src'
    dist : 'dist'

  grunt.initConfig
    yeoman: yeomanConfig

    coffee:
      dist:
        files: [
          expand: true
          cwd: '<%= yeoman.src %>'
          src: '{,*/}*.coffee'
          dest: '<%= yeoman.dist %>'
          ext: '.js'
        ]

    uglify:
      build:
        src: '<%=yeoman.dist %>/forty-datetime.js'
        dest: '<%=yeoman.dist %>/forty-datetime.min.js'

    # TODO Add testing
    # mochaTest:
    #   test:
    #     options:
    #       reporter: 'spec'
    #       compilers: 'coffee:coffee-script'
    #     src: ['test/**/*.coffee']
    #
    # karma:
    #   options:
    #     configFile: 'config/karma-conf.js'
    #   unit:
    #     singleRun: true
    #
    #
    # grunt.loadNpmTasks('grunt-karma')

    grunt.registerTask 'default', [
      #'mochaTest'
      'coffee'
      'uglify'
    ]
