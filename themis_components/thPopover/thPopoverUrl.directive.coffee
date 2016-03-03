angular.module('ThemisComponents')
  .directive "thPopoverUrl", ($http, PopoverManager) ->
    restrict: "A"
    scope: true
    link: ($scope, element, attributes) ->
      PopoverManager.attachPopover(
        $scope
        element
        attributes
        $http.get(attributes.thPopoverUrl)
      )
