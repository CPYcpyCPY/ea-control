'use strict';

var path = require('path');
var gulp = require('gulp');
var conf = require('./config');
var gulpSync = require('gulp-sync')(gulp);
var browserSync = require('browser-sync');
var server = require('gulp-develop-server');


/**
 * Determines if only change files, not add or delete files.
 *
 * @param      {<type>}   event   The event
 * @return     {boolean}  True if file changed, false if file deleted or added.
 */
function isOnlyChange(event)
{
    return event.type === 'changed';
}

/**
 * 监控文件变化
 */
gulp.task('watch', ['inject'], function ()
{
    // 监测主页面变化
    gulp.watch([path.join(conf.paths.src, '/app/*.html'), 'bower.json'], ['inject-reload']);

    // 监测css，sass,scss样式文件变化
    gulp.watch([
        path.join(conf.paths.src, '/app/**/*.css'),
        path.join(conf.paths.src, '/app/**/*.{scss,sass}')
    ], function (event)
    {
        if ( isOnlyChange(event) )
        {
            gulp.start('styles-reload');
        }
        else
        {
            gulp.start('inject-reload');
        }
    });

    // 监测js,ls,json文件变化
    gulp.watch([
      path.join(conf.paths.src, '/app/**/*.{js,ls,json.ls}'),
      path.join(conf.paths.src, '/app/*.{js,ls}')
    ], function (event)
    {
        if ( isOnlyChange(event) )
        {
            gulp.start('scripts-reload');
        }
        else
        {
            gulp.start('inject-reload');
        }
    });

    // 监测服务端文件变化
    gulp.watch(path.join(conf.paths.src, '/app-server/**/*.ls'),function(event)
    {
      gulp.start('server:rerun');
    });

    // 监测页面模块文件变化
    gulp.watch([
      path.join(conf.paths.src, '/app/**/*.json'),
      path.join(conf.paths.src, '/app/**/*.jade')
    ], function (event)
    {
        gulp.start('views-reload');
    });

});

gulp.task('server:rerun', gulpSync.sync(['scripts-reload', 'server:restart']));

gulp.task('server:restart', function() {

    server.restart(function() {
      browserSync.reload();
    });

});

// gulp.task('browser:reload', function() {

//     browserSync.reload();

// });

