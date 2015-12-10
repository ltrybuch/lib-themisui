angular.module 'ThemisComponents'
  .directive 'thTable', ($compile, Table) ->
    restrict: 'E'
    scope:
      delegate: '='
    bindToController: true
    controllerAs: 'thTable'
    controller: -> return
    compile: (element, attrs) ->
      table = new Table element
      table.clear()

      post: (scope, element, attrs, thTable) ->
        delegate = thTable.delegate
        template = table.post delegate
        childScope = scope.$parent.$new false, scope
        childScope.thTable = scope.thTable
        compiledTemplate = $compile(template) childScope
        element.append compiledTemplate
