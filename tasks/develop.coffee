paths = require './paths.json'
gulp = require 'gulp'
merge = require 'merge-stream'
plugins = require('gulp-load-plugins')(
  rename:
    'gulp-ng-classify': 'ngClassify'
    'gulp-angular-templatecache': 'ngTemplates'
    'gulp-angular-filesort': 'ngFileSort'
)
del = require 'del'


gulp.task 'clean', -> del paths.build


gulp.task 'bower', -> plugins.bower()


gulp.task 'libs', ->
  gulp.src(paths.bower_comp)
    .pipe plugins.concat('libs.js')
    .pipe gulp.dest paths.build_scripts


gulp.task 'scripts', ->
  gulp.src('src/scripts/**/*.coffee')
    .pipe plugins.plumber()
    .pipe plugins.sourcemaps.init()
    .pipe plugins.ngClassify()
    .pipe plugins.coffee()
    .pipe plugins.sourcemaps.write()
    .pipe gulp.dest paths.build_scripts
    .pipe plugins.livereload()


gulp.task 'styles', ->
  gulp.src(paths.styles)
    .pipe plugins.plumber()
    .pipe plugins.less()
    .pipe gulp.dest paths.build_styles
    .pipe plugins.livereload()


gulp.task 'templates', ->
  # Default file build/app/templates.js
  gulp.src(paths.templates)
    .pipe plugins.plumber()
    .pipe plugins.ngTemplates(module: 'app')
    .pipe gulp.dest('build/scripts/app')
    .pipe plugins.livereload()


gulp.task 'copy', ->
  locale = gulp.src('src/_locales/**').pipe gulp.dest 'build/_locales'
  images = gulp.src(paths.images).pipe gulp.dest 'build/images'
  fonts = gulp.src(paths.fonts).pipe gulp.dest 'build/fonts'
  manifest = gulp.src('src/manifest.json').pipe gulp.dest 'build'

  merge(locale, images, fonts, manifest)


gulp.task 'index', ->
  gulp.src('src/index.html')
    .pipe plugins.plumber()
    .pipe plugins.inject(gulp.src(['build/scripts/app/**/*.js']).pipe(plugins.ngFileSort()),
      name: 'scripts'
      addRootSlash: false
      ignorePath: 'build/'
    )
    .pipe plugins.inject(gulp.src('build/scripts/libs.js'),
      name: 'libs'
      addRootSlash: false,
      ignorePath: 'build/'
    )
    .pipe gulp.dest paths.build
    .pipe plugins.livereload()


gulp.task 'watch', ->
  plugins.livereload.listen()
  gulp.watch ['src/styles/**/*.less'], ['styles']
  gulp.watch ['src/scripts/**/*.coffee'], ['scripts']
  gulp.watch ['src/scripts/app/**/*.html'], ['templates']
  gulp.watch ['src/index.html'], ['index']

gulp.task 'default', ['build', 'watch']


gulp.task 'build',
  plugins.sequence(
    'clean'
    'bower'
    'libs'
    ['scripts', 'styles', 'templates','copy']
    'index'
  )
