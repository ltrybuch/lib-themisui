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

      @open = =>
        @expanded = true
        animateToggle()

      @close = =>
        @expanded = false
        animateToggle()

      animateToggle = =>
        height = getActualHeight $element
        if @expanded
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

      DisclosureManager.registerDisclosureContent @name, this

      return
