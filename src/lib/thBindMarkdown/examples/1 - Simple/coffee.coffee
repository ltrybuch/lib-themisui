angular.module('thDemo', ['ThemisComponents'])
  .controller 'DemoController', ($scope) ->
    $scope.markdownText = """
      # bob

      - one
      - two

      ```
      alert(1);
      ```
    """
