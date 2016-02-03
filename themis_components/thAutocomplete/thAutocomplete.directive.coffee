angular.module('ThemisComponents', ['ui.select'])
  .directive 'thAutocomplete', ($compile) ->
    restrict: 'E'
    scope:
      ngModel: '='
      delegate: '='
      placeholder: '@'
    bindToController: true
    controllerAs: 'thAutocomplete'
    controller: ($scope) ->
      @data = []

      @updateData = (data) =>
        throw new Error "UpdateData: data must be of type Array" unless data instanceof Array
        @data = data

      return
    compile: ->
      return (scope, element, attrs, controller) ->
        unless controller.delegate?.fetchData instanceof Function
          throw new Error "thAutocomplete delegate needs to be passed the following function: " + \
                          "fetchData: (searchTerm, updateData) ->"

        template = require './thAutocomplete.template.html'
        templateElement = angular.element(template)

        # Insert fetchData function into ui-select element
        selectChoicesElement = templateElement.find('ui-select-choices')
        selectChoicesElement.attr(
          'refresh',
          'thAutocomplete.delegate.fetchData($select.search, thAutocomplete.updateData)'
        )

        # ui-select needs access to the parent's scope for evaluating repeat
        childScope = scope.$parent.$new false, scope

        # We are attaching the table's controller to the scope, so that the
        # template has access to it
        childScope.thAutocomplete = scope.thAutocomplete

        compiledTemplate = $compile(templateElement) childScope
        element.append compiledTemplate
