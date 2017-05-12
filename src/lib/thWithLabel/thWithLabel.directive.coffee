angular.module('ThemisComponents')
  .directive "withLabel", ($compile) ->
    restrict: "A"
    # Note: Post links run in reverse priority order. So set 'withLabel'
    # directive first and then run 'withMessages' after. Counterintiutive yes,
    # but this is how it works.
    # https://docs.angularjs.org/api/ng/service/$compile
    priority: 1
    link: (scope, element, attrs) ->
      # wrap our input in a label
      element.wrap '<label class="th-label">'
      label = element.parent()

      scope.$watch attrs.ngRequired, (newVal) ->
        labelEl = element.parent()[0]
        requiredLabel = labelEl.getElementsByClassName("required-field")
        wrappedRequiredLabel = angular.element(requiredLabel)

        if newVal
          wrappedRequiredLabel.removeClass("hide")
        else
          wrappedRequiredLabel.addClass("hide")

      prependTooltipElement = ->
        tooltipTemplate = attrs.withTooltip
        scope.tooltipTemplate = tooltipTemplate
        tooltip = """<th-tooltip template="tooltipTemplate"></th-tooltip>"""
        tooltipEl = $compile(tooltip) scope

        label.prepend tooltipEl

      adjustMarginForRadioInputs = (element) ->
        # Reduce margin-bottom for radio button groups.
        isThRadio = element.classList.contains "th-radio-button"
        isThCheckbox = element.classList.contains "th-checkbox"
        isRadioInput = element.type is "radio"
        className = "radio-label" if isThRadio or isRadioInput
        className = "th-checkbox-label" if isThCheckbox
        label.addClass className

      createElementObject = ->
        elementObject = {el: null, type: "themis", inline: false}

        # Check th-radio-group first as th-radio-button are found inside
        # and can set th-radio-group to "inline" when it shouldn't be.
        radioGroupEl = label[0].getElementsByClassName "th-radio-group"
        return elementObject if radioGroupEl.length > 0

        # Set type to "themis" and inline to true
        classNames = ["th-switch", "th-checkbox", "th-radio-button"]
        classNames.map (className) ->
          temp = label[0].getElementsByClassName(className)[0]
          elementObject = {el: temp, type: "themis", inline: true} if temp?

        # Set type to "html" and inline to true
        unless elementObject.el?
          inputTypes = ["radio", "checkbox"]
          inputTypes.map (type) ->
            temp = label[0].querySelectorAll("input[type=#{type}]")[0]
            elementObject = {el: temp, type: "html", inline: true} if temp?

        return elementObject

      elementObject = createElementObject()

      # if element is deemed 'inline' then append the label else prepend the label
      if elementObject.inline
        label.append "<span class='inline label-text'>#{attrs.withLabel}</span>"
        adjustMarginForRadioInputs elementObject.el
      else
        prependTooltipElement() if attrs.withTooltip
        label.prepend "<div class='label-text'>#{attrs.withLabel}</div>"
      label.prepend """<span class='required-field'>required</span>"""

      element.on "click", (event) ->
        # If clicking on input element stop propagation to label.
        event.stopPropagation()
        # Allow underlying input element to handle click event.
        event.preventDefault() if elementObject.type is "themis"

      label.on "click", (event) ->
        if elementObject.type is "themis"
          event.preventDefault()
          # Pass the click event to the th-component.
          element[0].click()
