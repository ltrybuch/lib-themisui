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
    restrict: 'A'
    replace: true
    transclude: true
    scope:
      name: '@thDisclosureContent'
    template: require './thDisclosureContent.template.html'
    bindToController: true
    controllerAs: 'thDisclosureContent'
    controller: ($element) ->
      @expanded = false
      DisclosureManager.onToggle @name, =>
        @expanded = not @expanded
        height = getActualHeight $element
        if @expanded
          $($element).animate {
            height: "#{height}px"
          }, 300, ->
            $($element).css 'height', 'auto'
        else
          $($element).animate {
            height: "0"
          }, 300
