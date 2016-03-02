angular.module('ThemisComponents')
  .directive "thSelect", ->
    restrict: "EA"
    template: require './thSelect.template.html'
    controllerAs: "select"
    replace: true
    bindToController: true
    transclude: true
    scope:
      condensed: "="
      options: "="
      ngModel: "="
      name: "@"
      ngDisabled: "="
      ngChange: "&"
      ngRequired: "="
      placeholder: "@"

    controller: ($scope, $element, $attrs, $transclude) ->
      @selectedText = @placeholder
      @selectedText = @ngModel.name if @ngModel?
      @options ?= []

      isSelected = (element) -> element.hasAttribute "selected"

      isOptionElement = (element) -> element.tagName is "OPTION"

      # Add transcluded Option element to the @options array.
      angular.forEach $transclude(), (element) =>

        if element.tagName is "OPTGROUP"
          groupName = element.label
          groupedOptions = angular.element(element).find "option"

          angular.forEach groupedOptions, (option) =>

            if isOptionElement option
              @options.push
                name: option.text
                value: option.value
                group: groupName

              if isSelected option
                @ngModel =
                  name: option.text
                  value: option.value
                  group: groupName

        if isOptionElement element
          @options.push {name: element.text, value: element.value}

          if isSelected element
            @ngModel = {name: element.text, value: element.value}

      return

    link: (scope, element, attributes, controller) ->
      # On the model change, update the select's text
      scope.$watch ->
        controller.ngModel
      , (newValue) ->
        text = newValue?.name ? controller.placeholder
        controller.selectedText = text

      selectedElementCount = 0
      options = element.find "option"
      for option in options when option.hasAttribute "selected"
        selectedElementCount++

      if selectedElementCount > 1
        console.warn(
          "#{counter} options are set on a non-multiple select \
          (name: #{attributes.name}). The last selected option will be used."
        )

      # add box shadow on entire element when in focus
      select = element.find "select"
      select.on "focus", ->
        angular.element(this).next().addClass "has-focus"
      select.on "blur", ->
        angular.element(this).next().removeClass "has-focus"

      return
