module.exports = (grunt) ->

  (require 'load-grunt-tasks') grunt

  lib = grunt.file.readJSON 'lib.json'
  bwrrc = grunt.file.readJSON '.bowerrc'

  grunt.initConfig
    pkg: grunt.file.readJSON 'package.json'

    matchers:
      sass: '**/*.scss'
      jade: '**/*.jade'
      coffee: '**/*.coffee'
      js: '**/*.js'
      jsModules: '**/module.js'
      baseFiles: '**/base*.js'
      css: '**/*.css'
      html: '**/*.html'
      all: '**/*'

    paths:
      lib:
        base: bwrrc.directory
      src:
        base: 'src'
        sass: 'sass'
        jade: 'jade'
        coffee: 'coffee'
        index: 'index.jade'
        static: 'static'
      build:
        base: 'build'
        js: 'js'
        css: 'css'
        html: 'html'
      min:
        base: 'min'
      test:
        base: 'test'
        built: 'testjs'
      tmp:
        base: 'tmp'

    clean: {
      build: [
        '<%= paths.build.base %>'
      ]
      min: [
        '<%= paths.min.base %>'
      ]
      tempmin: [
        '<%= paths.min.base %>/<%= paths.build.html %>'
        '<%= paths.min.base %>/<%= paths.build.css %>'
        '<%= paths.min.base %>/<%= paths.build.js %>'
        '<%= paths.min.base %>/<%= paths.lib.base %>'
      ]
      test: [
        '<%= paths.tmp.base %>/<%= paths.test.built %>'
      ]
      temp: [
        '.sass-cache'
      ]
    },

    copy:
      buildLib:
        expand: true
        cwd: '<%= paths.lib.base %>/'
        src: '<%= matchers.all %>'
        dest: '<%= paths.build.base %>/<%= paths.lib.base %>/'
      buildStatic:
        expand: true
        cwd: '<%= paths.src.base %>/<%= paths.src.static %>/'
        src: '<%= matchers.all %>'
        dest: '<%= paths.build.base %>/'
      minLib:
        expand: true
        cwd: '<%= paths.build.base %>/'
        src: '<%= matchers.all %>'
        dest: '<%= paths.min.base %>/'
      minStatic:
        expand: true
        cwd: '<%= paths.src.base %>/<%= paths.src.static %>/'
        src: '<%= matchers.all %>'
        dest: '<%= paths.min.base %>/'

    coffeelint:
      app:
        files:
          src: [
            '<%= paths.src.base %>/<%= paths.src.coffee %>/<%= matchers.coffee %>'
          ]
        options:
          max_line_length:
            level: 'ignore'

    scsslint:
      app: [
        '<%= paths.src.base %>/<%= paths.src.sass %>/<%= matchers.sass %>'
      ],
      options:
        config: '.scss-lint.yml'

    coffee:
      app:
        expand: true
        flatten: false
        options:
          bare: true
        cwd: '<%= paths.src.base %>/<%= paths.src.coffee %>/'
        src: [
          '<%= matchers.coffee %>'
        ]
        dest: '<%= paths.build.base %>/<%= paths.build.js %>/'
        ext: '.js'
      test:
        expand: true
        flatten: false
        options:
          bare: true
        cwd: '<%= paths.test.base %>'
        src: [
          '<%= matchers.coffee %>'
        ]
        dest: '<%= paths.tmp.base %>/<%= paths.test.built %>'
        ext: '.js'

    jade:
      app:
        expand: true
        flatten: false
        cwd: '<%= paths.src.base %>/<%= paths.src.jade %>/'
        src: [
          '<%= matchers.jade %>'
        ]
        dest: '<%= paths.build.base %>/<%= paths.build.html %>/'
        ext: '.html'
        options:
          client: false
          pretty: true
      index:
        expand: true
        flatten: false
        cwd: '<%= paths.src.base %>/'
        src: ['index.jade']
        dest: '<%= paths.build.base %>/'
        ext: '.html'
        options:
          client: false
          pretty: true

    sass:
      app:
        expand: true
        flatten: false
        cwd: '<%= paths.src.base %>/<%= paths.src.sass %>/'
        src: [
          '<%= matchers.sass %>'
        ]
        dest: '<%= paths.build.base %>/<%= paths.build.css %>/'
        ext: '.css'

    tags:
      libjs:
        options:
          scriptTemplate: '<script type="text/javascript" src="{{path}}"></script>'
          openTag: '<!--libjs start-->'
          closeTag: '<!--libjs end-->'
        src: lib.js
        dest: '<%= paths.build.base %>/index.html'
      libcss:
        options:
          linkTemplate: '<link rel="stylesheet" type="text/css" href="{{path}}"/>'
          openTag: '<!--libcss start-->'
          closeTag: '<!--libcss end-->'
        src: lib.css
        dest: '<%= paths.build.base %>/index.html'
      appjs:
        options:
          scriptTemplate: '<script type="text/javascript" src="{{path}}"></script>'
          openTag: '<!--appjs start-->'
          closeTag: '<!--appjs end-->'
        src: [
          '<%= paths.build.base %>/<%= paths.build.js %>/app.js'
          '<%= paths.build.base %>/<%= paths.build.js %>/<%= matchers.jsModules %>'
          '<%= paths.build.base %>/<%= paths.build.js %>/<%= matchers.baseFiles %>'
          '<%= paths.build.base %>/<%= paths.build.js %>/<%= matchers.js %>'
        ]
        dest: '<%= paths.build.base %>/index.html'
      appcss:
        options:
          linkTemplate: '<link rel="stylesheet" type="text/css" href="{{path}}"/>'
          openTag: '<!--appcss start-->'
          closeTag: '<!--appcss end-->'
        src: [
          '<%= paths.build.base %>/<%= paths.build.css %>/<%= matchers.css %>'
        ]
        dest: '<%= paths.build.base %>/index.html'

    html2js:
      options:
        base: '<%= paths.min.base %>'
        module: 'templates'
      app:
        src: [
          '<%= paths.min.base %>/<%= paths.build.html %>/<%= matchers.html %>'
        ]
        dest: '<%= paths.min.base %>/<%= paths.build.js %>/templates.js'

    replace:
      min:
        src: ['<%= paths.min.base %>/index.html']
        overwrite: true
        replacements: [{
          from: 'APPVERSION'
          to: '<%= pkg.name %>-<%= pkg.version %>'
        },{
          from: 'LIBVERSION'
          to: '<%= pkg.name %>-<%= pkg.version %>.lib'
        }]

    useref:
      html: '<%= paths.min.base %>/index.html'
      temp: '<%= paths.min.base %>'

    jasmine:
      app:
        src: [
          '<%= paths.build.base %>/<%= paths.build.js %>/<%= matchers.jsModules %>'
          '<%= paths.build.base %>/<%= paths.build.js %>/<%= matchers.js %>'
          '<%= paths.tmp.base %>/<%= paths.test.built %>/<%= matchers.js %>'
        ]
        options:
          specs: '<%= paths.build.base %>/<%= paths.test.base %>/<%= matchers.js %>'
          vendor: lib.test || lib.js
          summary: true

    connect:
      min:
        options:
          base: '<%= paths.min.base %>/'
          open: true
          # livereload: true
      build:
        options:
          base: '<%= paths.build.base %>/'
          open: true
          # livereload: true

    watch:
      min:
        files: [
          '<%= paths.src.base %>/<%= paths.src.index %>'
          '<%= paths.src.base %>/<%= paths.src.coffee %>/<%= matchers.coffee %>'
          '<%= paths.src.base %>/<%= paths.src.sass %><%= matchers.sass %>'
          '<%= paths.src.base %>/<%= paths.src.jade %>/<%= matchers.jade %>'
          '<%= paths.src.base %>/<%= paths.test.base %>/<%= matchers.coffee %>'
        ]
        tasks: ['lint', 'build', 'min']
        options:
          # livereload: true
          interrupt: true
      build:
        files: [
          '<%= paths.src.base %>/<%= paths.src.coffee %>/<%= matchers.coffee %>'
          '<%= paths.src.base %>/<%= paths.src.sass %><%= matchers.sass %>'
          '<%= paths.src.base %>/<%= paths.src.jade %>/<%= matchers.jade %>'
          '<%= paths.src.base %>/<%= paths.test.base %>/<%= matchers.coffee %>'
        ]
        tasks: ['lint', 'build']
        options:
          # livereload: true,
          interrupt: true

  grunt.registerTask 'lint', ['coffeelint:app', 'scsslint:app']
  grunt.registerTask 'build', ['clean:build', 'copy:buildLib', 'copy:buildStatic', 'coffee:app', 'jade:app', 'jade:index', 'sass:app', 'clean:temp', 'tags:libjs', 'tags:appjs', 'tags:libcss', 'tags:appcss']
  grunt.registerTask 'test', ['clean:test', 'coffee:test', 'jasmine:app', 'clean:test']
  grunt.registerTask 'min', ['clean:min', 'copy:minLib', 'copy:minStatic', 'html2js:app', 'replace:min', 'useref', 'concat', 'uglify', 'cssmin', 'clean:tempmin']

  grunt.registerTask 'default', ['lint', 'build', 'connect:build', 'watch:build']
  grunt.registerTask 'once', ['lint', 'build', 'test', 'min']