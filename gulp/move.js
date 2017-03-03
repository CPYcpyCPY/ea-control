'use strict';

var path = require('path');
var gulp = require('gulp');
var conf = require('./config');
var $ = require('gulp-load-plugins')({
    pattern: ['gulp-*', 'merge-stream']
});

/**
 * move json files
 */
gulp.task('move', function(){

    return gulp.src(path.join(conf.paths.src, '/app/**/*.{json,html,css,js}'))
        .pipe(gulp.dest('app/'));

});
