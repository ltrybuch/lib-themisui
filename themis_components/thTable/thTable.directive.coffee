angular.module 'ThemisComponents'
  .directive 'thTable', ($compile, Table) ->
    restrict: 'E'
    scope:
      delegate: '='
    bindToController: true
    controllerAs: 'thTable'
    controller: -> return
    compile: (element, attrs) ->
      table = Table {element}
      table.clear()

      post: (scope, element, attrs, controller) ->
        table.setDelegate controller.delegate
        template = table.generateTableTemplate()
        childScope = scope.$parent.$new false, scope
        childScope.thTable = scope.thTable
        compiledTemplate = $compile(template) childScope
        element.append compiledTemplate
