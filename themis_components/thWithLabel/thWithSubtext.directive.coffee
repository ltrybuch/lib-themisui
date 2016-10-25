angular.module("ThemisComponents")
  .directive "withSubtext", ->
    priority: 2
    restrict: "A"
    link: (scope, element, attrs) ->
      label = element.parent()

      createElementObject = ->
        elementObject = {el: null, type: "themis", inline: false}
        # Check th-radio-group first as th-radio-button are found inside
        # and can set th-radio-group to "inline" when it shouldn't be.
        radioGroupEl = label[0].getElementsByClassName "th-radio-group"
        return elementObject if radioGroupEl.length > 0

        # Set type to "themis" and inline to true
        classNames = ["th-checkbox", "th-radio-button"]
        classNames.map (className) ->
          temp = label[0].getElementsByClassName(className)[0]
          elementObject = {el: temp, type: "themis", inline: true} if temp?

        # Set type to "html" and inline to true
        if elementObject.inline
          inputTypes = ["radio", "checkbox"]
          inputTypes.map (type) ->
            temp = label[0].querySelectorAll("input[type=#{type}]")[0]
            elementObject = {el: temp, type: "html", inline: true} if temp?

        return elementObject

      if attrs.withLabel?
        elementObject = createElementObject()

        # if element is deemed 'inline' then append it, otherwise it's not compatible
        if elementObject.inline
          label.addClass 'subtext-label'

          span = label[0].getElementsByClassName "label-text"
          label.children().addClass 'with-subtext'
          span[0].innerHTML += "<p class='inline sublabel-text'>#{attrs.withSubtext}</p>"
