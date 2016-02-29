angular.module('ThemisComponents')
  .directive "thPopover", (PopoverManager, $q) ->
    restrict: "A"
    scope: true
    bindToController: true
    controllerAs: "thPopover"
    controller: ($scope, $attrs) ->
      @getContent = ->
        $q (resolve, reject) ->
          content = PopoverManager.getContent $attrs.thPopover
          if content? then resolve({data: content}) else reject()

      return
    link: ($scope, element, attributes, controller) ->
      PopoverManager.addTarget($scope, element, attributes, controller.getContent)
