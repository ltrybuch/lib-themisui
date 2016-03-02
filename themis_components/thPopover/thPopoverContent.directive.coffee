angular.module("ThemisComponents")
  .directive "thPopoverContent", (PopoverManager) ->
    restrict: "E"
    compile: (tElement, tAttrs) ->
      unless tAttrs.name?.length > 0
        throw new Error "thPopoverContent: must specify name attribute."

      # Add element content to popover manager.
      PopoverManager.addContent(tAttrs.name, tElement[0].innerHTML)

      # Hide element in DOM
      tElement.attr('style', 'display: none;')

      return
