angular.module('ThemisComponents')
    .directive "withLabel", ->
      restrict: "A"
      link: (scope, element, attrs) ->
        Array.prototype.insert = (element) ->
          if element
            @.push element

        element.wrap '<label class="th-label">'
        label = element.parent()
        inlineComponents = []
        inlineComponents.insert label[0].getElementsByClassName("th-checkbox")[0]
        inlineComponents.insert label[0].getElementsByClassName("th-switch")[0]
        inlineComponents.insert label[0].querySelectorAll("input[type=checkbox]")[0]
        inlineComponents.insert label[0].querySelectorAll("input[type=radio]")[0]
        if inlineComponents.length > 0
          textSpan = angular.element "<span class='inline-label-text'>#{attrs.withLabel}</span>"
          label.append textSpan
          textSpan[0].click ->
            element[0].click()
        else
          label.prepend "<div class='label-text'>#{attrs.withLabel}</div>"


