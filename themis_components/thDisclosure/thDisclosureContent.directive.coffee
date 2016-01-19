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
    controller: ($scope, $element, $attrs, $transclude) ->
      previousScope = null

      # Re-appending content each time disclosure is opened.
      # This allows components to re-initialize. Useful for
      # components like 'with-focus' that set focus in initialize.
      appendContent = ->
        elementEmpty =  $element.children().length is 0
        if elementEmpty
          $transclude (cloneOfContent, transclusionScope) ->
            # Re-use the same scope with every open and close.
            previousScope = transclusionScope
            # Append the content of the disclosure to the element.
            $element.append cloneOfContent
        else
          $transclude previousScope, (cloneOfContent) ->
            # Inject previous scope to reuse on new content.
            # Remove element so they are not duplicated.
            $element.empty()
            $element.append cloneOfContent

      animateToggle = =>
        if @expanded
          appendContent()
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
