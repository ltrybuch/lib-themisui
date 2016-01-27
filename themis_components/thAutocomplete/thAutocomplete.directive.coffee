angular.module('ThemisComponents', ['ui.select'])
  .directive 'thAutocomplete', ($compile) ->
    restrict: 'E'
    scope:
      ngModel: '='
      delegate: '='
      placeholder: '@'
      data: '='
    bindToController: true
    controllerAs: 'thAutocomplete'
    controller: -> return
    compile: ->
      return (scope, element, attrs, controller) ->
        delegate = if controller.delegate? then controller.delegate else {}

        template = require './thAutocomplete.template.html'
        templateElement = angular.element(template)

        # Insert fetchData function into ui-select element if present
        if delegate.fetchData instanceof Function
          selectChoicesElement = templateElement.find('ui-select-choices')
          selectChoicesElement.attr('refresh', 'thAutocomplete.delegate.fetchData($select.search)')

        # ui-select needs access to the parent's scope for evaluating repeat
        childScope = scope.$parent.$new false, scope

        # We are attaching the table's controller to the scope, so that the
        # template has access to it
        childScope.thAutocomplete = scope.thAutocomplete

        compiledTemplate = $compile(templateElement) childScope
        element.append compiledTemplate
