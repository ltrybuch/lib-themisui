keycode = require "keycode"

angular
  .module('ThemisComponents')
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
    controller: ($scope, $element, $timeout) ->
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

      $scope.hasBadge = (tab) ->
        tab.badge?

      @addTab = (tab) ->
        $scope.activateTab tab if tabs.length is 0
        tabs.push tab

      $element.on 'keydown', (event) ->
        if angular.element(event.target).hasClass('tab-name')
          if event.keyCode == keycode('Right') ||
             event.keyCode == keycode('Left') ||
             event.keyCode == keycode('Up') ||
             event.keyCode == keycode('Down')
            event.preventDefault()

          $timeout ->
            if event.keyCode == keycode('Right') ||
               event.keyCode == keycode('Up')
              i = 0
              while i < $scope.tabs.length
                if $scope.tabs[i].active
                  if i == $scope.tabs.length - 1
                    firstTab = $element.find('li')[0]
                    angular.element(firstTab).triggerHandler 'click'
                    firstTab.focus()
                  else
                    nextTab = $element.find('li')[i + 1]
                    angular.element(nextTab).triggerHandler 'click'
                    nextTab.focus()
                  break
                else
                  i++

            if event.keyCode == keycode('Left') ||
               event.keyCode == keycode('Down')
              i = 0
              while i < $scope.tabs.length
                if $scope.tabs[i].active
                  if i == 0
                    lastTab = $element.find('li')[$scope.tabs.length - 1]
                    angular.element(lastTab).triggerHandler 'click'
                    lastTab.focus()
                  else
                    previousTab = $element.find('li')[i - 1]
                    angular.element(previousTab).triggerHandler 'click'
                    previousTab.focus()
                  break
                else
                  i++

      return
