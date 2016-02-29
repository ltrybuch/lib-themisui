angular.module('ThemisComponents')
  .directive "thPopover", (PopoverManager, $q) ->
    restrict: "A"
    scope: true
    link: ($scope, element, attributes) ->
      getContent =  ->
        $q (resolve, reject) ->
          content = PopoverManager.getContent attributes.thPopover
          if content? then resolve({data: content}) else reject()

      PopoverManager.addTarget($scope, element, attributes, getContent)
