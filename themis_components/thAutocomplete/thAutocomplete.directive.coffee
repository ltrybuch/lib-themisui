angular.module('ThemisComponents', ['ui.select'])
  .directive 'thAutocomplete', ($compile) ->
    restrict: 'E'
    scope:
      name: '@'
      ngModel: '='
      fetchData: '&'
      repeat: '@'
    bindToController: true
    controllerAs: 'thAutocomplete'
    controller: -> return
    compile: (element, attrs) =>
      @innerHTML = element.html()

      return (scope, element, attrs, controller, transcludeFn) =>
        template = require './thAutocomplete.template.html'
        
        # Insert result template into directive template.
        templateElement = angular.element(template)
        templateElement[0].querySelector('ui-select-choices').innerHTML = @innerHTML

        # ui-select needs access to the parent's scope for evaluating repeat.
        childScope = scope.$parent.$new false, scope

        # We are attaching the table's controller to the scope, so that the
        # template has access to it.
        childScope.thAutocomplete = scope.thAutocomplete

        compiledTemplate = $compile(templateElement) childScope
        element.append compiledTemplate
