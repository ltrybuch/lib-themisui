angular.module('ThemisComponents')
  .directive "thPopoverUrl", ($http, PopoverManager) ->
    restrict: "A"
    scope: true
    link: ($scope, element, attributes) ->
      getContent = ->
        $http.get attributes.thPopoverUrl

      PopoverManager.addTarget($scope, element, attributes, getContent)
