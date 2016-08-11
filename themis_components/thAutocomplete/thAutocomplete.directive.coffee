angular.module 'ThemisComponents'
  .directive 'thAutocomplete', ($compile, $interpolate) ->
    restrict: 'E'
    scope:
      ngModel: '=?'
      ngChange: '&'
      delegate: '='
      name: '@'
      placeholder: '@'
      icon: '@'
      condensed: "="
    bindToController: true
    controllerAs: 'thAutocomplete'

    controller: ->
      @data = []

      @updateData = (data) =>
        throw new Error "UpdateData: data must be of type Array" unless data instanceof Array
        @data = data

      return

    link: (scope, element, attrs, controller) ->
      delegate = controller.delegate
      unless delegate?.fetchData instanceof Function
        throw new Error "thAutocomplete delegate needs to be passed the following function: " + \
                        "fetchData: ({searchTerm}, updateData) ->"

      template = (require "./thAutocomplete.template")({
        interpolateStart: $interpolate.startSymbol()
        interpolateEnd: $interpolate.endSymbol()
        valueField: delegate.trackField ? "id"
      })
      templateElement = angular.element template

      # Add repeat attribute to ui-select-choices element.
      repeatExpression = 'item in thAutocomplete.data'
      if delegate.trackField?
        repeatExpression += " track by item.#{delegate.trackField}"

      selectChoicesElement = templateElement.find 'ui-select-choices'
      selectChoicesElement.attr(
        'repeat'
        repeatExpression
      )

      # Add display field to inner html of ui-select-choices and ui-select-match elements.
      displayField = delegate.displayField ? 'name'

      selectChoicesElement.html "<span ng-bind='item.#{displayField}'></span>"

      selectMatchElement = templateElement.find 'ui-select-match'
      selectMatchElement.html "<span ng-bind='$select.selected.#{displayField}'></span>"

      # ui-select needs access to the parent's scope for evaluating repeat.
      childScope = scope.$parent.$new false, scope

      # We are attaching the table's controller to the scope, so that the
      # template has access to it.
      childScope.thAutocomplete = scope.thAutocomplete

      compiledTemplate = $compile(templateElement) childScope
      element.append compiledTemplate
