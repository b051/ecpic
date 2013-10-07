module.exports = (grunt) ->
  version = ->
    grunt.file.readJSON("package.json").version
  version_tag = ->
    "v#{version()}"

  grunt.initConfig
    pkg: grunt.file.readJSON("package.json")

    minified_comments: "/* Ecpic #{version_tag()} | (c) 2011-2013 by Rex Sheng */\n"

    'string-replace':
      cloudcode:
        files:
          'cloudcode/': ['coffee/*.coffee', 'coffee/shared/*.coffee']
        options:
          replacements: [
            pattern: /#ifndef\sCloudCode[\s\S]*?#endif/g
            replacement: ''
          ,
            pattern: /require\s["']\.\/(.*)["']/g
            replacement: "require 'cloud/$1'"
          ]
    
    coffee:
      heroku:
        cwd: 'coffee', src: ['*.coffee'], dest: 'heroku/', ext: '.js', flatten: yes, expand:yes, options:
          bare: yes
      cloudcode:
        cwd: 'cloudcode/coffee', src: ['**/*.coffee'], dest: 'cloud/', ext: '.js', flatten: no, expand:yes, options:
          bare: yes
      backbone:
        cwd: 'coffee', src: ['shared/*.coffee', 'views/*.coffee'], dest: 'public/js/', ext: '.js', flatten: yes, expand:yes, options:
          sourceMap: yes
          bare: yes
    
    uglify:
      options:
        mangle:
          except: ['jQuery', 'App', 'Parse']
        banner: "<%= minified_comments %>"
      minified_chosen_js:
        files:
          'public/octopus.min.js': ['public/octopus.js']

    cssmin:
      minified_chosen_css:
        options:
          banner: "<%= minified_comments %>"
        src: ['public/css/code-editor.css', 'public/css/elements.css', 'public/css/icons.css', 'public/css/layout.css', 'public/css/compiled/*.css']
        dest: 'public/octopus.min.css'

    watch:
      scripts:
        files: ['coffee/shared/*.coffee', 'coffee/views/*.coffee']
        tasks: ['default']

    copy:
      parse:
        files: [
          src: ["node_modules/parse/build/parse-latest.js"], dest: "public/parse/", expand: true, flatten: true, filter: 'isFile'
        ]
      dist:
        files: [
          { cwd: "public", src: ["img/**", "font/**", "lib/**", "index.html", "css/bootstrap/**", "css/lib/**", "octopus.min.js", "octopus.min.css"], dest: "dist/", expand: true, flatten: false, filter: 'isFile' }
          { src: ["chosen/public/chosen.min.css", "chosen/public/chosen.jquery.min.js", "chosen/public/chosen-sprite*.png"], dest: "dist/lib/chosen/", expand: true, flatten: true, filter: 'isFile' }
          { src: ["node_modules/parse/build/parse-latest.js"], dest: "dist/lib/parse/", expand: true, flatten: true, filter: 'isFile' }
        ]

    clean:
      heroku:
        'heroku/*.js'
      cloudcode:
        'cloudcode'

    build_gh_pages:
      gh_pages: {}

    dom_munger:
      download_links:
        src: 'public/index.html'
        options:
          callback: ($) ->
            $("#latest_version").attr("href", version_url()).text("Stable Version (#{version_tag()})")

    zip:
      chosen:
        cwd: 'public/'
        src: ['public/**/*']
        dest: "chosen_#{version_tag()}.zip"

  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-uglify'
  grunt.loadNpmTasks 'grunt-contrib-concat'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-contrib-copy'
  grunt.loadNpmTasks 'grunt-contrib-clean'
  grunt.loadNpmTasks 'grunt-contrib-compass'
  grunt.loadNpmTasks 'grunt-contrib-cssmin'
  grunt.loadNpmTasks 'grunt-build-gh-pages'
  grunt.loadNpmTasks 'grunt-string-replace'
  grunt.loadNpmTasks 'grunt-zip'
  grunt.loadNpmTasks 'grunt-dom-munger'

  grunt.registerTask 'default', ['copy:parse', 'coffee:backbone']
  grunt.registerTask 'heroku', ['default', 'clean:heroku', 'coffee:heroku']
  grunt.registerTask 'parse', ['default', 'string-replace:cloudcode', 'coffee:cloudcode', 'clean:cloudcode']
  grunt.registerTask 'gh_pages', ['clean', 'copy', 'build_gh_pages:gh_pages']
