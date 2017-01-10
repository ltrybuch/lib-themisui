keycode = require "keycode"

angular.module("ThemisComponents")
  .directive "thButton", ->
    restrict: "EA"
    scope:
      type: "@"
      href: "@"
      loading: "=?"
      ngDisabled: "&?"
    replace: true
    transclude: true
    template: (element, attrs) ->
      switch
        when attrs.href?
          require "./thButton.anchor.template.html"
        else
          require "./thButton.button.template.html"
    bindToController: true
    controllerAs: "button"
    controller: ($scope, $element, $attrs) ->
      @loading ||= no
      @ngDisabled ?= false

      types = ["standard", "create", "destroy"]
      @theme = if @type?.toLowerCase() in types then "light" else "dark"

      # In HTML5 a button with no type attribute is "submit" by default.
      # If not used for submit, must explicitly specify "button".
      isSubmit = $attrs.submit? or $attrs.type is "submit"
      type = if isSubmit then "submit" else "button"
      $element.attr "type", type

      @setDisabled = ->
        $element.attr "disabled", "disabled"

      @setEnabled = ->
        $element.removeAttr "disabled"

      $scope.$watch =>
        @loading
      , (newValue) =>
        if newValue is false
          if $attrs.disabled is "" or $attrs.disabled is true
            @setDisabled()
          else
            @setEnabled()
        else
          @setDisabled()

      $element.on "keyup", (event) ->
        if event.keyCode is keycode "Enter" or
           event.keyCode is keycode "Space"
          $element.triggerHandler "click"

      return
