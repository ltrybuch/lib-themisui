angular.module 'ThemisComponents'
  .directive 'thTable', ->
    restrict: 'E'
    scope:
      objects: '='
    template: require './thTable.template.html'
    bindToController: true
    controllerAs: 'thTable'
    controller: ->
      return
