angular.module("ThemisComponents")
  .directive "withFocus", ($timeout) ->
    restrict: "A"
    link: (scope, element) ->
      setFocus = (el) ->
        # Set to 300ms to account for modal CSS transition time.
        $timeout ->
          scope.$apply el[0].focus()
        , 301

      # If this is a thComponent we need to set focus on the inner element.
      thComponentTypes = ["select", "input"]
      thComponent = (element.find(type) for type in thComponentTypes \
                      when element.find(type).length)

      setFocus(thComponent[0] ? element)
