angular.module('ThemisComponents')
  .directive "thSelect", ->
    restrict: "EA"
    template: require './thSelect.template.html'
    controllerAs: "select"
    replace: true
    bindToController: true
    transclude: true
    require: ["?^form", "thSelect"]
    scope:
      condensed: "="
      options: "="
      ngModel: "="
      name: "@"
      ngDisabled: "="
      ngChange: "&"
      ngRequired: "="
      placeholder: "@"
      nameField: "@?"
      valueField: "@?"

    controller: ($scope, $element, $attrs, $transclude) ->
      @selectedText = @placeholder
      @selectedText = @ngModel.name if @ngModel?
      @options ?= []
      @nameField ?= "name"
      @valueField ?= "value"

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

    link: (scope, element, attribute, controllerArray) ->
      form = controllerArray[0] ? null
      controller = controllerArray[1]
      fieldName = controller.name ? null

      # If input value is invalid append invalid class.
      controller.isInvalid = ->
        return no unless fieldName and form
        form[fieldName].$invalid && (form[fieldName].$touched or form.$submitted)


      # Toggle color based on placeholder text visibility.
      textElement = element[0].getElementsByClassName("text-wrapper")[0]

      setTextToLightGrey = ->
        textElement.className += " light-grey"

      setTextToDarkGrey = ->
        classes = textElement.className.replace "light-grey", ""
        textElement.className = classes

      # On the model change, update the select's text
      scope.$watch ->
        controller.ngModel
      , (newValue) ->
        if newValue?.name?
          controller.selectedText = newValue.name
          setTextToDarkGrey()
        else
          controller.selectedText = controller.placeholder
          setTextToLightGrey()

      selectedElementCount = 0
      options = element.find "option"
      for option in options when option.hasAttribute "selected"
        selectedElementCount++

      if selectedElementCount > 1
        console.warn(
          "#{counter} options are set on a non-multiple select \
          (name: #{attributes.name}). The last selected option will be used."
        )

      # Toggle box-shadow.
      select = element.find "select"
      select.on "focus", (event) ->
        event.target.previousElementSibling.classList.add "has-focus"
      select.on "blur", (event) ->
        event.target.previousElementSibling.classList.remove "has-focus"

      return
