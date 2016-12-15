angular.module "ThemisComponents"
  .directive "thDisclosureToggle", (DisclosureManager) ->
    restrict: "E"
    transclude: true
    scope:
      name: "@"
      expanded: "=?"
      ngDisabled: "=?"
      textSide: "@"
      ariaLabel: "@"
      ariaDescribedby: "@"
      tabindex: "@"
    template: require './thDisclosureToggle.template.html'
    bindToController: true
    controllerAs: 'thDisclosureToggle'
    controller: ($scope, $element) ->
      @textSide ||= "left"
      @tabindex = "-1"

      @toggle = =>
        unless @ngDisabled
          DisclosureManager.updateState @name, not @expanded

      @focus = ->
        @tabindex = "0"

      @blur = ->
        @tabindex = "-1"

      DisclosureManager.registerDisclosureToggle @name, {
        handleOpen: =>
          @expanded = true

        handleClose: =>
          @expanded = false
      }

      # Only set a watch if we have something bound to @expanded.
      if @expanded?
        $scope.$watch =>
          @expanded
        , =>
          DisclosureManager.updateState @name, @expanded
      else
        DisclosureManager.updateState @name, false

      return
