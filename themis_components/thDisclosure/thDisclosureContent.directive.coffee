$ = require 'jquery'

getActualHeight = (element) ->
  previousCss = $(element).attr "style"
  $(element).css
    position: 'absolute'
    visibility: 'hidden'
    display: 'block'
    height: 'auto'
  height = $(element).height()
  $(element).attr "style", previousCss ? ""
  height

open = (element) ->
  $(element).css
    height: 'auto'
    overflow: 'visible'

close = (element) ->
  $(element).css overflow: 'hidden'

angular.module 'ThemisComponents'
  .directive 'thDisclosureContent', (DisclosureManager) ->
    restrict: 'E'
    transclude: true
    scope:
      name: '@'
    template: require './thDisclosureContent.template.html'
    bindToController: true
    controllerAs: 'thDisclosureContent'
    controller: ($element) ->

      animateToggle = =>
        height = getActualHeight $element
        if @expanded
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
