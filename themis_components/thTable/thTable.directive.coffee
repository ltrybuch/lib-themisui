angular.module 'ThemisComponents'
  .directive 'thTable', ($compile, Table) ->
    restrict: 'E'
    scope:
      delegate: '='
    bindToController: true
    controllerAs: 'thTable'
    controller: -> return
    compile: (element, attrs) ->
      table = Table {element: element[0]}
      table.clear()

      return post: (scope, element, attrs, controller) ->
        table.setDelegate controller.delegate
        template = table.generateTableTemplate()

        # The scope used for the table template will be a child of thTable's
        # scope that inherits from thTable's parent scope.
        #
        # This is so that the contents of <th-table-row>s have access to the
        # outside scope, as if they were transcluded.
        childScope = scope.$parent.$new false, scope

        # We are attaching the table's controller to the scope, so that the
        # template has access to it.
        childScope.thTable = scope.thTable

        compiledTemplate = $compile(template) childScope
        element.append compiledTemplate
