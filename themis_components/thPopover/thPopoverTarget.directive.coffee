angular.module("ThemisComponents")
  .directive "thPopoverTarget", (PopoverManager) ->
    restrict: "A"
    link: (scope, element, attributes) ->
      unless attributes.thPopoverTarget?.length > 0
        throw new Error "thPopoverTarget: must specify name."

      PopoverManager.addTarget(
        attributes.thPopoverTarget
        scope
        element
        attributes
      )
