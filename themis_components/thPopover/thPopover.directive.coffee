angular.module('ThemisComponents')
  .directive "thPopover", (PopoverManager) ->
    restrict: "A"
    link: ($scope, element, attributes) ->
      unless attributes.thPopover?.length > 0
        throw new Error "thPopover: must specify content name."

      PopoverManager.attachPopover(
        element
        attributes
        PopoverManager.getContent(attributes.thPopover)
      )
