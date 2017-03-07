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

        # Set type to "themis" and inline to true/false depending on the class
        classNames = ["select-wrapper", "th-checkbox", "th-radio-button", "th-input-wrapper"]
        classNames.map (className) ->
          switch className
            when "select-wrapper", "th-input-wrapper" then inline = false
            else inline = true
          temp = label[0].getElementsByClassName(className)[0]
          elementObject = {el: temp, type: "themis", inline: inline} if temp?

        return elementObject

      if attrs.withLabel?
        elementObject = createElementObject()

        # if element is deemed 'inline' then append it, otherwise it's not compatible
        if elementObject.inline
          label.addClass 'subtext-label'

          span = label[0].getElementsByClassName "label-text"
          label.children().addClass 'with-subtext'
          span[0].innerHTML += "<p class='inline sublabel-text'>#{attrs.withSubtext}</p>"
        else
          label.addClass 'subtext-label'
          subtextParagraph =
            angular.element "<p class='block sublabel-text'>#{attrs.withSubtext}</p>"

          input = label[0].getElementsByClassName elementObject.el.className
          label.children().addClass 'with-subtext'
          angular.element(input).after subtextParagraph
