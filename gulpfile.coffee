gulp = require 'gulp'
plugins = require('gulp-load-plugins')()
del = require 'del'

BC = 'bower_components'

paths =
  styles: 'src/styles/style.less'
  images: 'src/images/*'
  fonts: "#{BC}/font-awesome/fonts/*"
  build: 'build'
  build_scripts: 'build/scripts'
  build_styles: 'build/styles'
  bower_comp: [
    "#{BC}/jquery/dist/jquery.js"
  ]
  scripts: [
    'build/scripts/app/app.js'
  ]


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


# TODO: Merge streams
gulp.task 'copy', ->
  gulp.src('src/_locales/**').pipe gulp.dest 'build/_locales'
  gulp.src(paths.images).pipe gulp.dest 'build/images'
  gulp.src(paths.fonts).pipe gulp.dest 'build/fonts'
  gulp.src('src/manifest.json').pipe gulp.dest 'build'
  gulp.src('src/index.html').pipe gulp.dest 'build'
  .pipe plugins.livereload()


gulp.task 'inject', ->
  gulp.src('src/index.html')
    .pipe plugins.plumber()
    .pipe plugins.inject(gulp.src(paths.scripts),
      addRootSlash: false
      ignorePath: 'build/'
    )
    .pipe plugins.inject(gulp.src('build/scripts/libs.js'),
      name: 'libs'
      addRootSlash: false,
      ignorePath: 'build/'
    )
    .pipe gulp.dest paths.build


gulp.task 'watch', ->
  plugins.livereload.listen()
  gulp.watch ['src/styles/**/*.less'], ['styles']
  gulp.watch ['src/scripts/**/*.coffee'], ['scripts']
  gulp.watch ['src/**/*.html'], ['copy']


gulp.task 'default', ['build', 'watch']


gulp.task 'build',
  plugins.sequence(
    'clean'
    'bower'
    'libs'
    ['scripts', 'styles', 'copy']
    'inject'
  )
