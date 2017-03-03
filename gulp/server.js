var path = require('path');
var gulp = require('gulp');
var conf = require('./config');

var browserSync = require('browser-sync');
var browserSyncSpa = require('browser-sync-spa');
var server = require('gulp-develop-server');

var util = require('util');

gulp.task('browser:run', function() {
  browserSync.init({
    proxy: 'http://localhost:3000',
  });
});

gulp.task('serve', ['watch'], function() {
    server.listen({path: './app-server/server.js'}, function() {
        gulp.start('browser:run');
    });
    // browserSyncInit([path.join(conf.paths.tmp, '/serve'), conf.paths.src]);
});
