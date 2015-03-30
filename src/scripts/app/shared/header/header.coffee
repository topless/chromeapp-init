class AppHeader extends Directive
  constructor: ->
    header =
      restrict: 'A'
      templateUrl: 'shared/header/header.html'
    return header
