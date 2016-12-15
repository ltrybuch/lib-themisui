$ = require "jquery"

getActualHeight = (element) ->
  previousCss = $(element).attr "style"
  $(element).css
    position: "absolute"
    visibility: "hidden"
    display: "block"
    height: "auto"
  height = $(element).height()
  $(element).attr "style", previousCss ? ""
  height

open = (element) ->
  $(element).css
    height: "auto"
    overflow: "visible"
  $(element).attr "aria-hidden", "false"

close = (element) ->
  $(element).css
    overflow: "hidden"
    display: "none"
  $(element).attr "aria-hidden", "true"

angular.module "ThemisComponents"
  .directive "thDisclosureContent", (DisclosureManager) ->
    restrict: "E"
    transclude: true
    scope:
      name: "@"
    template: require "./thDisclosureContent.template.html"
    bindToController: true
    controllerAs: "thDisclosureContent"
    controller: ($element, $scope) ->
      $element.attr "id", $scope.thDisclosureContent.name
      $element.attr "aria-labelledby", $scope.thDisclosureContent.name + "-toggle"

      animateToggle = =>
        height = getActualHeight $element
        if @expanded
          $($element).css display: "block"
          $($element).stop().animate {
            height: "#{height}px"
          }, 300, ->
            open $element
        else
          $($element).stop().animate {
            height: "0"
          }, 300, ->
            close $element
        return false

      @expanded = false
      DisclosureManager.registerDisclosureContent @name, {
        handleOpen: =>
          @expanded = true
          animateToggle()

        handleClose: =>
          @expanded = false
          animateToggle()
      }

      return
