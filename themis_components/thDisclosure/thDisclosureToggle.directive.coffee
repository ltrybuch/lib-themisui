angular.module 'ThemisComponents'
  .directive 'thDisclosureToggle', (DisclosureManager) ->
    restrict: 'A'
    replace: true
    transclude: true
    scope:
      name: '@thDisclosureToggle'
    template: require './thDisclosureToggle.template.html'
    bindToController: true
    controllerAs: 'thDisclosureToggle'
    controller: ($element) ->
      @expanded = false

      @toggle = =>
        @expanded = not @expanded
        DisclosureManager.toggle @name
        return

      @
