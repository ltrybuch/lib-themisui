angular.module 'ThemisComponents'
  .directive 'thTableCell', ->
    restrict: 'E'
    require: '^thTable'
    template: require './thTableCell.template.html'
    bindToController: true
    controllerAs: 'thTableCell'
    controller: ->
      return
    link: (scope, element, attrs, thTable) ->
      return
