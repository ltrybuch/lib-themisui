angular.module('ThemisComponents')
  .directive "thTabset", ->
    restrict: "EA"
    replace: true
    template: require './thTabset.native.template.html'
    transclude: true
    scope:
      type: "@"
    controller: ($scope) ->
      tabs = $scope.tabs = []

      if $scope.type
        acceptableTypes = ["sub-header"]
        unless $scope.type in acceptableTypes
          throw new Error "thTabset: invalid 'type'."

      $scope.processTabChange = (tabToSelect) ->
        $scope.activateTab tabToSelect

        # Evaluate ngClick function only if tabs have loaded.
        tabToSelect.ngClick() if typeof tabToSelect.ngClick is "function"

      $scope.activateTab = (tabToSelect) ->
        tabToSelect.active = yes
        tab.active = no for tab in tabs when tab isnt tabToSelect

      @addTab = (tab) ->
        $scope.activateTab tab if tabs.length is 0
        tabs.push tab

      return
