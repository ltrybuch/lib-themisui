angular.module('ThemisComponents')
  .directive "withLabel", ->
    restrict: "A"
    link: (scope, element, attrs) ->

      # wrap our input in a label
      element.wrap '<label class="th-label">'
      label = element.parent()

      findInlineInputElement = (themisComponents, htmlComponents) ->
        # find themis ui components by class name
        findByClassName = (className) ->
          label[0].getElementsByClassName(className)[0]

        # find inline inputs by type
        findByInputType = (type) ->
          label[0].querySelectorAll("input[type=#{type}]")[0]

        html = (findByInputType(comp) \
                 for comp in htmlComponents \
                 when findByInputType(comp) isnt undefined)

        themis = (findByClassName(comp) \
                   for comp in themisComponents \
                   when findByClassName(comp) isnt undefined)

        if themis[0]
          el: themis[0], type: "themis"
        else
          el: html[0], type: "html"

      inlineElement = findInlineInputElement(
        ["th-switch", "th-checkbox", "th-radio-button"]
        ["radio", "checkbox"]
      )

      # if element is deemed 'inline' the append the label else prepend the label
      if inlineElement.el
        label.append "<span class='inline label-text'>#{attrs.withLabel}</span>"
      else
        label.prepend "<div class='label-text'>#{attrs.withLabel}</div>"

      element.on "click", (event) ->
        # If clicking on input element stop propagation to label.
        event.stopPropagation()
        # Allow underlying input element to handle click event.
        event.preventDefault() if inlineElement.type is "themis"

      label.on "click", (event) ->
        if inlineElement.type is "themis"
          event.preventDefault()
          # Pass the click event to the th-component.
          element[0].click()
