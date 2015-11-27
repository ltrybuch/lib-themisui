angular.module 'ThemisComponents'
  .directive 'thTable', ($compile, Table) ->
    restrict: 'E'
    scope:
      delegate: '='
    bindToController: true
    controllerAs: 'thTable'
    controller: ->
    compile: (element, attrs, transclude) ->
      table = new Table element
      table.clear()
      post: (scope, element, attrs, thTable) ->
        delegate = thTable.delegate
        template = table.post delegate
        compiledTemplate = $compile(template)(scope)
        element.append compiledTemplate