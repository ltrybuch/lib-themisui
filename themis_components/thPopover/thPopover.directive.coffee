angular.module('ThemisComponents')
  .directive "thPopover", (PopoverManager) ->
    restrict: "A"
    scope: true
    link: ($scope, element, attributes) ->
      unless attributes.thPopover?.length > 0
        throw new Error "thPopover: must specify content name."

      PopoverManager.attachPopover(
        $scope
        element
        attributes
        PopoverManager.getContent(attributes.thPopover)
      )
