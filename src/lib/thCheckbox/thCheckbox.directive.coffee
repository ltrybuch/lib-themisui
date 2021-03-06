keycode = require "keycode"

angular.module('ThemisComponents')
  .directive "thCheckbox", ->
    restrict: "EA"
    replace: true
    template: require "./thCheckbox.template.html"
    scope:
      name: "@"
      change: "&ngChange"
      checked: "=?ngModel"
      ngRequired: "="
      ngDisabled: "="
      indeterminate: "=?"
    bindToController: true
    controllerAs: "checkbox"
    controller: ($scope, $element) ->
      @toggle = ->
        $scope.$apply =>
          @checked = not @checked
        @change() if @change?

      $element.on "click", =>
        @indeterminate = no
        @toggle() unless $element.attr("disabled")

      $element.on "keydown", (event) ->
        if event.keyCode is keycode("Space")
          event.preventDefault()
          $element.triggerHandler "click"

      return
