template = """
  <div
    class="th-tab"
    ng-if="active"
    ng-transclude
    ></div>
"""

angular.module('ThemisComponents')
  .directive "thTab", ->
    require: "^thTabset"
    restrict: "E"
    template: template
    transclude: true
    scope:
      name: "@name"
    link: (scope, element, attrs, controller) ->
      scope.active = no
      controller.addTab scope