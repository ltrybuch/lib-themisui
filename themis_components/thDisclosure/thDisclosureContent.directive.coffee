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
    bindToController: true
    controllerAs: 'thDisclosureContent'
    controller: ($scope, $element, $transclude) ->

      processContent = ->
        $transclude (transEl) ->
          isEmpty = $element.children().length == 0
          $element.append transEl if isEmpty

      animateToggle = =>
        if @expanded
          processContent()
          height = getActualHeight $element
          $($element).animate {
            height: "#{height}px"
          }, 300, ->
            open $element
        else
          $($element).animate {
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
