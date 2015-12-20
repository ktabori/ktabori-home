'use strict';

var request = require('request');

module.exports = function (grunt) {
  // show elapsed time at the end
  require('time-grunt')(grunt);
  // load all grunt tasks
  require('load-grunt-tasks')(grunt);

  var reloadPort = 35729, files;

  grunt.initConfig({
    pkg: grunt.file.readJSON('package.json'),
    develop: {
      server: {
        file: 'app.js'
      }
    },
    less: {
      dist: {
        files: {
          'public/css/core.css': 'public/less/core.less'
        }
      }
    },
    coffee: {
      options: {
        bare: true
      },
      compile: {
        files: {
          'public/coffee/core.tmp.js': ['public/coffee/*.coffee']
        }
      }
    },
    uglify: {
      dev: {
        options: {
          mangle: false,
          compress: false,
          beautify: true
        },
        files: { 'public/js/core.js':
          [ 'public/libs/jquery.min.js',
            'public/libs/bootstrap.js',
            'public/libs/flexslider.min.js',
            'public/libs/lightbox.min.js',
            'public/libs/masonry.min.js',
            'public/libs/twitterfetcher.min.js',
            'public/libs/spectragram.min.js',
            'public/libs/ytplayer.min.js',
            'public/libs/countdown.min.js',
            'public/libs/smooth-scroll.min.js',
            'public/libs/parallax.js',
            'public/libs/scripts.js',
            'public/coffee/core.tmp.js'
          ]
        }
      },
    },
    watch: {
      options: {
        nospawn: true,
        livereload: reloadPort
      },
      coffee: {
        files: [
          'public/**/*.coffee'
        ],
        tasks: ['coffee', 'uglify', 'delayed-livereload']
      },
      js: {
        files: [
          'app.coffee',
          'app/**/*.coffee',
          'config/*.coffee',
        ],
        tasks: ['develop', 'delayed-livereload']
      },
      css: {
        files: [
          'public/less/**/*.less'
        ],
        tasks: ['less'],
        options: {
          livereload: reloadPort
        }
      },
      views: {
        files: [
          'app/views/*.jade',
          'app/views/**/*.jade'
        ],
        options: { livereload: reloadPort }
      }
    }
  });

  grunt.config.requires('watch.js.files');
  files = grunt.config('watch.js.files');
  files = grunt.file.expand(files);

  grunt.registerTask('delayed-livereload', 'Live reload after the node server has restarted.', function () {
    var done = this.async();
    setTimeout(function () {
      request.get('http://localhost:' + reloadPort + '/changed?files=' + files.join(','),  function(err, res) {
          var reloaded = !err && res.statusCode === 200;
          if (reloaded)
            grunt.log.ok('Delayed live reload successful.');
          else
            grunt.log.error('Unable to make a delayed live reload.');
          done(reloaded);
        });
    }, 500);
  });

  grunt.registerTask('prod', [
    'less',
    'coffee',
    'uglify'
  ]);

  grunt.registerTask('default', [
    'less',
    'coffee',
    'uglify',
    'develop',
    'watch'
  ]);
};
