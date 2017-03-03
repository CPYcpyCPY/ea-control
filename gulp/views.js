'use strict';

var path = require('path');
var gulp = require('gulp');
var conf = require('./config');
var browserSync = require('browser-sync');
var $ = require('gulp-load-plugins')({
    pattern: ['gulp-*', 'merge-stream']
});


gulp.task('views-reload', ['views'], function() {

    return buildViews().pipe(browserSync.stream());

})

gulp.task('views', function(){

    return buildViews();

});

/**
 * 将jade文件编译, 并将编译后文件和原有HTML文件(除index.html)，放到根目录下
 */
function buildViews() {

    var _jade = conf.jade();
    var _html = gulp.src([
        '!' + path.join(conf.paths.src, '/app/index.html'),
        path.join(conf.paths.src, '/app/**/*.html')
        ]);
    return $.mergeStream(_jade, _html)
        .pipe(gulp.dest('app/'));

}
