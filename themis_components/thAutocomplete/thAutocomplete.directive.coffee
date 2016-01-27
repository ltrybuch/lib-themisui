angular.module('ThemisComponents', ['ui.select'])
  .directive 'thAutocomplete', ($compile) ->
    restrict: 'E'
    scope:
      name: '@'
      ngModel: '='
      delegate: '='
      placeholder: '@'
    bindToController: true
    controllerAs: 'thAutocomplete'
    controller: -> return
    compile: (element, attrs) ->
      # @innerHTML = element.find('th-option').html()

      return (scope, element, attrs, controller, transcludeFn) ->
        delegate = if controller.delegate? then controller.delegate else {}

        template = require './thAutocomplete.template.html'
        templateElement = angular.element(template)

        # Query select-choices element
        selectChoicesElement = templateElement.find('ui-select-choices')

        # Insert fetchData function if present
        if delegate.fetchData instanceof Function
          selectChoicesElement.attr('refresh', 'thAutocomplete.delegate.fetchData($select.search)')

        # Insert result template
        # selectChoicesElement[0].innerHTML = @innerHTML

        # ui-select needs access to the parent's scope for evaluating repeat
        childScope = scope.$parent.$new false, scope

        # We are attaching the table's controller to the scope, so that the
        # template has access to it
        childScope.thAutocomplete = scope.thAutocomplete

        compiledTemplate = $compile(templateElement) childScope
        element.append compiledTemplate
