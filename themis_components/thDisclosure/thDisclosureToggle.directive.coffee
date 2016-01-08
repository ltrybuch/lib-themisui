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

      @open = =>
        @expanded = true

      @close = =>
        @expanded = false

      updateManager = =>
        if @expanded
          DisclosureManager.open @name
        else
          DisclosureManager.close @name

      # only set a watch if we have something bound to @expanded
      if @expanded?
        $scope.$watch =>
          @expanded
        , -> updateManager()

      @expanded = @expanded ? false
      DisclosureManager.registerDisclosureToggle @name, this
      updateManager()

      return
