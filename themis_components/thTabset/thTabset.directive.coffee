template = """
  <div class="th-tabset">
    <div class="th-tab-bar">
        <a
          href=""
          ng-click="activateTab(tab)"
          ng-repeat="tab in tabs"
          ng-class="{active:tab.active}"
          >{{ tab.name }}</a>
    </div>
    <div
      class="th-tabset-content"
      ng-transclude
      ></div>
  </div>
"""

angular.module('ThemisComponents')
  .directive "thTabset", ->
    restrict: "EA"
    replace: true
    template: template
    transclude: true
    scope: {}
    controller: ($scope) ->
      tabs = $scope.tabs = []

      $scope.activateTab = (tabToSelect) ->
        tabToSelect.active = yes
        tab.active = no for tab in tabs when tab isnt tabToSelect

      @addTab = (tab) ->
        $scope.activateTab tab if tabs.length is 0
        tabs.push tab