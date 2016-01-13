angular.module("ThemisComponents")
  .directive "withFocus", ($timeout) ->
    restrict: "A"
    link: (scope, element) ->
      setFocus = (el) ->
        # Set to 301ms to account for th-modal's CSS transition time.
        $timeout ->
          scope.$apply el[0].focus()
        , 301

      # If this is a thComponent we need to set focus on the inner element.
      thComponentTypes = ["select", "input"]
      thComponent = thComponentTypes
                      .map (type) -> element.find(type)
                      .find (result) -> result.length > 0

      setFocus thComponent ? element
