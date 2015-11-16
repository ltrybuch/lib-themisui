angular.module 'ThemisComponents'
  .directive 'thDisclosureToggle', (DisclosureManager) ->
    restrict: 'E'
    transclude: true
    scope:
      name: '@'
    template: require './thDisclosureToggle.template.html'
    bindToController: true
    controllerAs: 'thDisclosureToggle'
    controller: ($element) ->
      @expanded = false

      @toggle = =>
        @expanded = not @expanded
        DisclosureManager.toggle @name
        return

      return
