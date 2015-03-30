# TODO: Bump up version in manifest.
# TODO: Build .crx chrome-app and .apk android

paths = require './paths.json'
gulp = require 'gulp'
del = require 'del'
plugins = require('gulp-load-plugins')(
  rename:
    'gulp-minify-css': 'mincss'
    'gulp-angular-filesort': 'ngFileSort'
)


gulp.task 'release',
  plugins.sequence(
    'build'
    'minStyles'
    'concatSource'
    'cleanSource'
    'minScripts'
    'injectMin'
  )


gulp.task 'minStyles', ->
  gulp.src('build/styles/*.css')
    .pipe plugins.plumber()
    .pipe plugins.mincss(keepBrakes: false)
    .pipe gulp.dest('build/styles')


gulp.task 'concatSource', ->
  gulp.src(['build/scripts/app/**/*.js'])
    .pipe plugins.ngFileSort()
    .pipe plugins.concat('app.js')
    .pipe gulp.dest paths.build_scripts


gulp.task 'cleanSource', ->
  del "#{paths.build_scripts}/app"


gulp.task 'minScripts', ->
  gulp.src "#{paths.build_scripts}/*js"
    .pipe plugins.uglify()
    .pipe gulp.dest paths.build_scripts


gulp.task 'injectMin', ->
  gulp.src('build/index.html')
    .pipe plugins.plumber()
    .pipe plugins.inject(gulp.src('build/scripts/app.js'),
      name: 'scripts'
      addRootSlash: false
      ignorePath: 'build/'
    )
    .pipe gulp.dest paths.build
