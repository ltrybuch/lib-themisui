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
      @expanded = false

      @animateToggle = =>
        @expanded = not @expanded
        height = getActualHeight $element
        if @expanded
          $($element).animate {
            height: "#{height}px"
          }, 300, ->
            $($element).css
              height: 'auto'
              overflow: 'visible'
        else
          $($element).animate {
            height: "0"
          }, 300, ->
            $($element).css overflow: 'hidden'

      DisclosureManager.onToggle @name, => @animateToggle()

      return
