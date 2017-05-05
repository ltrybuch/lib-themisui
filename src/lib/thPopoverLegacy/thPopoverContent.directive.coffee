angular.module("ThemisComponents")
  .directive "thPopoverContent", (PopoverManager) ->
    restrict: "E"
    link: (scope, element, attributes) ->
      unless attributes.name?.length > 0
        throw new Error "thPopoverContent: must specify name attribute."

      # Add element content to popover manager.
      PopoverManager.addContent(attributes.name, element[0].innerHTML, scope)

      # Hide element in DOM
      element.attr('style', 'display: none;')

      return
