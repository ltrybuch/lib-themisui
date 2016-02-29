angular.module('ThemisComponents')
  .directive "thPopoverUrl", ($http, PopoverManager) ->
    restrict: "A"
    scope: true
    link: ($scope, element, attributes) ->
      getContent = (success, failure) ->
        $http.get attributes.thPopoverUrl
        .then (response) ->
          success(response.data)
        , ->
          failure()

      PopoverManager.addTarget($scope, element, attributes, getContent)
