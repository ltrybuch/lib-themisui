angular.module("ThemisComponents")
  .directive "withFocus", ($timeout, $rootScope) ->
    restrict: "A"
    link: (scope, element) ->
      setFocus = (el) ->
        $timeout ->
          scope.$apply el[0].focus()
        , 0

      # If this is a thComponent we need to set focus on the inner element.
      thComponentTypes = ["select", "input"]
      thComponent = thComponentTypes
                      .map (type) -> element.find(type)
                      .find (result) -> result.length > 0

      setFocus thComponent ? element

      # Listen for parent container to finish its transition
      ["th-disclosure.expanded", "th-modal.open"].map (event) ->
        $rootScope.$on event, -> setFocus thComponent ? element
