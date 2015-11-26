angular.module 'ThemisComponents'
  .directive 'thTableRow', ->
    restrict: 'E'
    require: '^thTable'
    bindToController: true
    controllerAs: 'thTableRow'
    controller: ->
      return
    link: (scope, element, attrs, thTable) ->
      return
