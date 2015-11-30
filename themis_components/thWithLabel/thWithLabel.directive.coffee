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

        html = (findByInputType(comp) for comp in htmlComponents when findByInputType(comp) isnt undefined)
        themis = (findByClassName(comp) for comp in themisComponents when findByClassName(comp) isnt undefined)

        if themis[0]
          el: themis[0], type: "themis"
        else
          el: html[0], type: "html"

      inlineElement = findInlineInputElement(
        ["th-switch", "th-checkbox"]
        ["radio", "checkbox"]
      )

      # if element is deemed 'inline' the append the label else prepend the label
      if inlineElement.el
        textSpan = angular.element "<span class='inline label-text'>#{attrs.withLabel}</span>"
        label.append textSpan

        # if element is not a native input we need to extend the click over to our styled faux input.
        textSpan.on "click", ->
          element[0].click() if inlineElement.type == "themis"
      else
        label.prepend "<div class='label-text'>#{attrs.withLabel}</div>"
