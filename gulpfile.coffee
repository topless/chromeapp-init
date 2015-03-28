gulp = require 'gulp'
plugins = require('gulp-load-plugins')()
plugins.mainBowerFiles = require 'main-bower-files'
del = require 'del'

paths =
  bower: 'bower_components'
  styles: 'src/styles/style.less'
  images: 'src/images/*'
  build: 'build'
  build_scripts: 'build/scripts'
  build_styles: 'build/styles'
  libs: [
    'build/lib/jquery/dist/jquery.js'
    'build/lib/bootstrap/js/transition.js'
    'build/lib/bootstrap/js/collapse.js'
  ]
  scripts: [
    'build/scripts/app/app.js'
  ]


gulp.task 'bower', -> plugins.bower()


gulp.task 'clean', ->
  del paths.build


gulp.task 'lib', ['bower'], ->
  gulp.src plugins.mainBowerFiles(), base: paths.bower
    .pipe gulp.dest 'build/lib'


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


gulp.task 'copy', ->
  gulp.src('src/_locales/**').pipe gulp.dest 'build/_locales'
  gulp.src(paths.images).pipe gulp.dest 'build/images'
  gulp.src('src/manifest.json').pipe gulp.dest 'build'
  gulp.src('src/index.html').pipe gulp.dest 'build'
  .pipe plugins.livereload()


gulp.task 'inject', ->
  gulp.src('src/index.html')
    .pipe plugins.plumber()
    .pipe plugins.inject(gulp.src(paths.libs), addRootSlash: false, ignorePath: 'build/', name: 'libs')
    .pipe plugins.inject(gulp.src(paths.scripts), addRootSlash: false, ignorePath: 'build/')
    .pipe gulp.dest("build")


gulp.task 'watch', ->
  plugins.livereload.listen()
  gulp.watch ['src/styles/**/*.less'], ['styles']
  gulp.watch ['src/scripts/**/*.coffee'], ['scripts']
  gulp.watch ['src/**/*.html'], ['copy']


gulp.task 'default', [
  'build'
]

gulp.task 'build',
  plugins.sequence(
    'bower'
    'clean'
    'lib'
    ['scripts', 'styles', 'copy']
    'inject'
    'watch'
  )
