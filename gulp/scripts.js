'use strict';

var path = require('path');
var gulp = require('gulp');
var conf = require('./config');

var browserSync = require('browser-sync');

var $ = require('gulp-load-plugins')({
    pattern: ['gulp-*', 'merge-stream']
});

gulp.task('scripts-reload', ['scripts'], function ()
{
    buildScripts().pipe(browserSync.stream());
});

gulp.task('scripts', function ()
{
    return buildScripts();
});

/**
 * 合并src目录下原有js流和livescript编译流,并放到根目录下
 */
function buildScripts()
{
    var _livescript = conf.livescript();
    var _javascript = gulp.src(path.join(conf.paths.src, '/app/**/*.js'), {base: conf.paths.src})

    return $.mergeStream(_javascript, _livescript)
        .pipe(gulp.dest('./'));
        // Enable the following two lines if you want linter
        // to check your code every time the scripts reloaded
        //.pipe($.eslint())
        //.pipe($.eslint.format())

        // .pipe($.debug());
    return gulp.src()
};

