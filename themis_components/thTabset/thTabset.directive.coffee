angular.module('ThemisComponents')
  .directive "thTabset", ->
    restrict: "EA"
    replace: true
    template: require './thTabset.native.template.html'
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

      return
