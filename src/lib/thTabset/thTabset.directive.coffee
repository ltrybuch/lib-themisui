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
      activeTab: "<"
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

      # If the newly visible tab is the ONLY tab visible we'll
      # set it as the active tab.
      @setActiveIfOnlyVisibleTab = (tabAdded) ->
        activeTab = tabs.find (tab) -> tab.active
        if activeTab and not activeTab.show
          $scope.processTabChange tabAdded

      # When a tab that was active is removed. We need to replace the
      # active state with the next in line. Similar to how browser tabs work.
      @setNextActiveTab = (tabRemoved) ->
        idx = tabs.indexOf tabRemoved

        # We'll just check to see if we can assign the active state to
        # the tab to the left of the just hidden tab.
        if idx > 0 and tabRemoved.active
          tabToActivate = checkForVisibleTabsRightToLeft idx
          $scope.processTabChange tabToActivate if tabToActivate

        # If there is NOT a tab to the left we'll then check the right side.
        if idx < (tabs.length - 1) and tabRemoved.active
          tabToActivate = checkForVisibleTabsLeftToRight idx
          $scope.processTabChange tabToActivate if tabToActivate

      checkForVisibleTabsRightToLeft = (idx) ->
        for index in [(idx - 1) .. 0]
          return tabs[index] if tabs[index].show

      checkForVisibleTabsLeftToRight = (idx) ->
        for index in [(idx + 1) .. (tabs.length - 1)]
          return tabs[index] if tabs[index].show

      @addTab = (tab) ->
        $scope.activateTab tab if tabs.length is 0
        $scope.activateTab tab if tab.name is $scope.activeTab
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
