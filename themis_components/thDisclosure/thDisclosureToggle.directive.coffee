angular.module 'ThemisComponents'
  .directive 'thDisclosureToggle', (DisclosureManager) ->
    restrict: 'E'
    transclude: true
    scope:
      name: '@'
      expanded: '@'
    template: require './thDisclosureToggle.template.html'
    bindToController: true
    controllerAs: 'thDisclosureToggle'
    controller: ->
      DisclosureManager.setDefaultState @name, (@expanded ? false)

      @toggle = =>
        @expanded = not @expanded
        DisclosureManager.toggle @name
        return

      return
