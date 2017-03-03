var gulp = require('gulp'),
    apidoc = require('gulp-apidoc');

gulp.task('apidoc',function(done){
              apidoc({
                  src: "src/",
                  dest: "doc/api/",
                  template: "node_modules/apidoc/template/",
                  debug: true,
                  includeFilters: [ ".*\\.ls$" ]
              },done);
});
