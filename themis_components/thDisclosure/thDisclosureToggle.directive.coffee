angular.module 'ThemisComponents'
  .directive 'thDisclosureToggle', (DisclosureManager) ->
    restrict: 'E'
    transclude: true
    scope:
      name: '@'
      expanded: '='
    template: require './thDisclosureToggle.template.html'
    bindToController: true
    controllerAs: 'thDisclosureToggle'
    controller: ($scope) ->

      @toggle = =>
        DisclosureManager.toggle @name

      updateManager = =>
        if @expanded
          DisclosureManager.open @name
        else
          DisclosureManager.close @name

      # Only set a watch if we have something bound to @expanded.
      if @expanded?
        $scope.$watch =>
          @expanded
        , -> updateManager()

      @expanded = @expanded ? false
      DisclosureManager.registerDisclosureToggle @name, {
        handleOpen: =>
          @expanded = true
        handleClose: =>
          @expanded = false
      }
      updateManager()

      return
