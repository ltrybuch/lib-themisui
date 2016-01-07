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

      @expanded = @expanded ? false
      DisclosureManager.registerDisclosureToggle @name, this
      updateManager()

      $scope.$watch =>
        @expanded
      , -> updateManager()

      return
