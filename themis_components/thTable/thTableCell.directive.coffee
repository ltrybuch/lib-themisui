angular.module 'ThemisComponents'
  .directive 'thTableCell', ->
    restrict: 'E'
    require: '^thTable'
    scope:
      "header-title": '@'
    template: require './thTableCell.template.html'
    bindToController: true
    controllerAs: 'thTableCell'
    controller: ->
      return
    compile: (element, attrs, transclude) ->
      return
    link: (scope, element, attrs, thTable) ->
      return
