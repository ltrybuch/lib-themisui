angular.module 'ThemisComponents'
  .directive 'thTable', (Table) ->
    restrict: 'E'
    scope:
      delegate: '='
    bindToController: true
    controllerAs: 'thTable'
    controller: ->
    compile: (element, attrs, transclude) ->
      table = new Table element
      table.compile()
      post: (scope, element, attrs, thTable) ->
        table.post thTable.delegate
