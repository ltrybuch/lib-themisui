angular.module("ThemisComponents")
  .directive "thPopoverUrl", ($http, PopoverManager) ->
    restrict: "A"
    link: (scope, element, attributes) ->
      unless attributes.thPopoverUrl?.length > 0
        throw new Error "thPopoverUrl: must specify url."

      PopoverManager.attachPopover(
        element
        -> {
          getContentPromise: -> $http.get(attributes.thPopoverUrl)
          contentScope: scope
        }
      )
