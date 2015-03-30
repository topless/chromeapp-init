class Header extends Controller
  constructor: (@$location) ->

  gotoMain: ->
    @$location.path('/')

  gotoSearch: ->
    @$location.path('/search')


class AppHeader extends Directive
  constructor: ->
    header =
      restrict: 'A'
      templateUrl: 'shared/header/header.html'
      controller: 'headerController'
      controllerAs: 'header'
    return header
