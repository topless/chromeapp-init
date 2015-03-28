gulp = require 'gulp'
plugins = require('gulp-load-plugins')()
plugins.mainBowerFiles = require 'main-bower-files'
del = require 'del'

paths =
  lib: 'lib'
  bower: 'bower_components'
  scripts: 'src/scripts/**/*.coffee'
  images: 'src/images/*'
  build: 'build'
  build_scripts: 'build/scripts'


gulp.task 'bower', -> plugins.bower()


gulp.task 'clean', ->
  del paths.lib
  del paths.build


gulp.task 'lib', ['bower'], ->
  gulp.src plugins.mainBowerFiles(), base: paths.bower
    .pipe gulp.dest paths.lib


gulp.task 'scripts', ->
  gulp.src(paths.scripts)
    .pipe plugins.plumber()
    .pipe plugins.sourcemaps.init()
    .pipe plugins.coffee()
    .pipe plugins.sourcemaps.write()
    .pipe gulp.dest paths.build_scripts


gulp.task 'copy', ->
  gulp.src('src/_locales/**').pipe gulp.dest 'build/_locales'
  gulp.src(paths.images).pipe gulp.dest 'build/images'
  gulp.src('src/manifest.json').pipe gulp.dest 'build'
  gulp.src('src/index.html').pipe gulp.dest 'build'


gulp.task 'default', [
  'build'
]

gulp.task 'build',
  plugins.sequence 'bower', 'clean', 'lib', ['scripts', 'copy']
