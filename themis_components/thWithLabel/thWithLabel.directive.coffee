angular.module('ThemisComponents')
    .directive "withLabel", ->
      restrict: "A"
      link: (scope, element, attrs) ->
        # only add if element found
        Array.prototype.insert = (element) ->
          if element
            @.push element

        # wrap our input in a label
        element.wrap '<label class="th-label">'
        label = element.parent()
        # check for 'inline' input elements that should have a label inline
        inlineComponents = []
        inlineComponents.insert label[0].getElementsByClassName("th-checkbox")[0]
        inlineComponents.insert label[0].getElementsByClassName("th-switch")[0]
        inlineComponents.insert label[0].querySelectorAll("input[type=checkbox]")[0]
        inlineComponents.insert label[0].querySelectorAll("input[type=radio]")[0]
        # if element is deemed 'inline' the append the label else prepend the label
        if inlineComponents.length > 0
          textSpan = angular.element "<span class='inline-label-text'>#{attrs.withLabel}</span>"
          label.append textSpan
          label.on "click", ->
            element[0].click()
        else
          label.prepend "<div class='label-text'>#{attrs.withLabel}</div>"


