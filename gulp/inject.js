'use strict';

var path = require('path');
var gulp = require('gulp');
var gulpSync = require('gulp-sync')(gulp);
var conf = require('./config');

var $ = require('gulp-load-plugins')({
    pattern: ['gulp-*', 'merge-stream']
});

var wiredep = require('wiredep').stream;
var _ = require('lodash');

var browserSync = require('browser-sync');

gulp.task('inject-reload', ['inject'], function ()
{
    browserSync.reload();
});

var jsonFilter = $.filter(['**/*', '!**/*.json'], {restore: true});


/**
 *  将css和js文件注入到index.html,并将HTML放到public目录下
 */
gulp.task('inject', gulpSync.sync(['scripts', 'views', 'styles', 'move']), function ()
{
    return injectFiles();
});

gulp.task('inject-again', function() {

    return injectFiles();

});

function injectFiles() {

    var injectStyles = gulp.src([
        'app/**/*.css',
        '!app/vendor.css'
    ], {read: false, base: './'});

    var injectScripts = gulp.src([
        'app/**/*.js',
        'app/*.js'
        ])
        .pipe(jsonFilter)
        .pipe($.angularFilesort()).on('error', conf.errorHandler('AngularFilesort'))
        .pipe(jsonFilter.restore)

    var injectOptions = {
        addPrefix: 'app',
        relative: true
        // ignorePath: '/'
    };

    return gulp.src('app/index.html')
        .pipe($.inject(injectStyles, injectOptions))
        .pipe($.inject(injectScripts, injectOptions))
        .pipe(wiredep({ignorePath: new RegExp('(\.\.\/){1,}')}, conf.wiredep))
        .pipe(gulp.dest('app/'));

}
