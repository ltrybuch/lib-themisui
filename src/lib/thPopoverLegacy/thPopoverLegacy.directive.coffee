angular.module('ThemisComponents')
  .directive "thPopoverLegacy", (PopoverManager) ->
    restrict: "A"
    link: (scope, element, attributes) ->
      unless attributes.thPopoverLegacy?.length > 0
        throw new Error "thPopoverLegacy: must specify content name."

      PopoverManager.attachPopover(
        element
        -> PopoverManager.getContent attributes.thPopoverLegacy
      )
