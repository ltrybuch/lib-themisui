angular.module("ThemisComponents")
  .directive "withFocus", ($timeout) ->
    restrict: "A"
    link: (scope, element) ->
      setFocus = (el) ->
        # Set to 75 ms to account for modal opening time.
        $timeout ->
          scope.$apply el[0].focus()
        , 75

      # If this is a thComponent we need to set focus on the inner element.
      thComponentTypes = ["select", "input"]
      thComponent = (element.find(type) for type in thComponentTypes \
                      when element.find(type).length)

      setFocus(thComponent[0] ? element)
