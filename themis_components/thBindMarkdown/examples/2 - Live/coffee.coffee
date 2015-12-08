angular.module('thDemo', ['ThemisComponents'])
  .controller 'DemoController', ($scope) ->
    $scope.markdownText = "# Sample Markdown"
