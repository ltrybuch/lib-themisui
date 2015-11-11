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
      @toggleExpanded = =>
        @expanded = not @expanded
        DisclosureManager.toggleExpanded @name
        return # TODO: Why do I need to return?
      return # TODO: Do I need to return?
