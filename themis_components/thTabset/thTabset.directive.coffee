angular.module('ThemisComponents')
  .directive "thTabset", ->
    restrict: "EA"
    replace: true
    template: require './thTabset.native.template.html'
    transclude: {
      actionBar: '?thTabActionBar'
    }
    scope:
      activeTab: "="
      type: "@"
    controller: ($scope) ->
      tabs = $scope.tabs = []

      $scope.$watch (-> $scope.activeTab), -> $scope.setActiveTab()

      if $scope.type
        acceptableTypes = ["header", "sub-header"]
        unless $scope.type in acceptableTypes
          throw new Error "thTabset: invalid 'type'."

      $scope.processTabChange = (tabToSelect) ->
        $scope.activateTab tabToSelect

        # Evaluate ngClick function only if tabs have loaded.
        tabToSelect.ngClick() if typeof tabToSelect.ngClick is "function"

      $scope.activateTab = (tabToSelect) ->
        tabToSelect.active = yes
        tab.active = no for tab in tabs when tab isnt tabToSelect

      $scope.setActiveTab = ->
        $scope.activateTab tab for tab in tabs when tab.name is $scope.activeTab

      @addTab = (tab) ->
        $scope.activateTab tab if tabs.length is 0
        tabs.push tab

      return
