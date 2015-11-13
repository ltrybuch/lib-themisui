angular.module('ThemisComponents')
  .directive 'thContentHeader', ->
    restrict: "AE"
    scope:
      title: "@"
    transclude: true
    template: """
      <h1 class="th-header-title th-header-flex-item">{{ title }}</h1>
      <div class="th-header-flex-item"></div>
      <ng-transclude class="th-header-flex-item"></ng-transclude>
    """
