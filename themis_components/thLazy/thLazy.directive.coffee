template = """
  <ng-include onload="loadingComplete()" src="src"></ng-include>
  <div class="th-lazy-loader" ng-if="!loaded">
    <i class="fa fa-spin fa-refresh"></i> Loading&#8230;
  </div>
"""

angular.module('ThemisComponents')
  .directive "thLazy", ->
    restrict: "EA"
    template: template
    scope:
      src: "@src"
    controller: ($scope) ->
      $scope.loaded = no
      $scope.loadingComplete = -> $scope.loaded = yes
