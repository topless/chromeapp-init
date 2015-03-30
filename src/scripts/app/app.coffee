
class App extends App
  constructor: ->
    return [
      'ngRoute'
      'ngMaterial'
    ]


class Routes extends Config
  constructor: ($routeProvider) ->
    $routeProvider
    .when '/',
      templateUrl: 'components/main/main.html'
      controller: 'mainController'
      controllerAs: 'main'
    .when '/search',
      templateUrl: 'components/search/search.html'
      controller: 'searchController'
      controllerAs: 'search'
    .otherwise
      redirectTo: '/'


class Location extends Config
  constructor = ($locationProvider) ->
    $locationProvider.html5Mode
      enabled: true
      requireBase: false


# Custom whitelist to obey paths inside the packaged app
class Compile extends Config
  constructor: ($compileProvider) ->
    $compileProvider.aHrefSanitizationWhitelist(
      /^\s*(https?|file|blob|ftp|mailto|eyetribe|intent|c‌​hrome-extension):/
    )


class Theme extends Config
  constructor: ($mdThemingProvider) ->
    $mdThemingProvider
      .theme('default')
      .primaryPalette('blue-grey')
