angular.module 'ThemisComponents'
  .directive 'thAutocomplete', ($compile, $interpolate, $timeout) ->
    restrict: 'E'
    scope:
      ngModel: '=?'
      ngChange: '&?'
      delegate: '='
      name: '@?'
      placeholder: '@?'
      icon: '@?'
      condensed: "=?"
      multiple: "@?"
    bindToController: true
    controllerAs: 'thAutocomplete'

    controller: ->
      @data = []
      @lastValue = null

      @updateData = (data) =>
        throw new Error "UpdateData: data must be of type Array" unless data instanceof Array
        @data = data

      @onSelect = ->
        if @lastValue isnt @ngModel?[@trackField]
          @lastValue = @ngModel?[@trackField]
          @ngChange?()

      return

    link: (scope, element, attrs, controller) ->
      multiple = controller.multiple?
      delegate = controller.delegate
      unless delegate?.fetchData instanceof Function
        throw new Error "thAutocomplete delegate needs to be passed the following function: " + \
                        "fetchData: ({searchTerm}, updateData) ->"

      controller.trackField = delegate.trackField ? "id"

      template = (require "./thAutocomplete.template")({
        interpolateStart: $interpolate.startSymbol()
        interpolateEnd: $interpolate.endSymbol()
        valueField: controller.trackField
        multiple: if multiple then "multiple" else ""
      })
      templateElement = angular.element template

      # Add repeat attribute to ui-select-choices element.
      repeatExpression = "item in thAutocomplete.data track by item.#{controller.trackField}"

      selectChoicesElement = templateElement.find 'ui-select-choices'
      selectChoicesElement.attr(
        'repeat'
        repeatExpression
      )

      # Add display field to inner html of ui-select-choices and ui-select-match elements.
      displayField = delegate.displayField ? 'name'

      selectChoicesElement.html "<span ng-bind='item.#{displayField}'></span>"

      selectMatchHtml =
        if multiple
          "<span ng-bind='$item.#{displayField}'></span>"
        else
          "<span ng-bind='$select.selected.#{displayField}'></span>"

      selectMatchElement = templateElement.find 'ui-select-match'
      selectMatchElement.html selectMatchHtml

      # ui-select needs access to the parent's scope for evaluating repeat.
      childScope = scope.$parent.$new false, scope

      # We are attaching the table's controller to the scope, so that the
      # template has access to it.
      childScope.thAutocomplete = scope.thAutocomplete

      compiledTemplate = $compile(templateElement) childScope
      element.append compiledTemplate

      if multiple
        $timeout ->
          # Toggle container shadow when input has focus.
          search = angular.element(element[0].querySelectorAll(".ui-select-search"))
          container = angular.element(element[0].querySelectorAll(".ui-select-container"))
          search.on "focus", ->
            container.addClass("has-focus")
          search.on "blur", ->
            container.removeClass("has-focus")
