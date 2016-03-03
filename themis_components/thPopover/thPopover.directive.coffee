angular.module('ThemisComponents')
  .directive "thPopover", (PopoverManager) ->
    restrict: "A"
    scope: true
    link: ($scope, element, attributes) ->
      PopoverManager.attachPopover(
        $scope
        element
        attributes
        PopoverManager.getContent(attributes.thPopover)
      )
