overlayTemplate = """
  <div class="th-popover-overlay"></div>
"""

template = """
  <div class="th-popover-view">
    <i></i>
    <div
      class="th-popover-content"
      ng-include="templateURL"
      onload="templateLoaded()"
      ></div>
  </div>
"""

###

Note to self. This should probably be switched to an actual http request. It will give us much more control over the behaviour.

###

angular.module('ThemisComponents')
  .directive "thPopover", ($compile) ->
    restrict: "A"
    scope:
      templateURL: '=thPopover'
    link: ($scope, element, attributes) ->
      view = null
      arrow = null
      overlay = null

      $scope.$on 'thPopover.templateLoaded', ->
        minLeft = 12
        minRight = 12
        anchorRect = element[0].getBoundingClientRect()
        viewRect = view[0].getBoundingClientRect()

        maxWidth = window.innerWidth - minLeft*2 - minRight
        viewWidth = Math.min maxWidth, viewRect.width

        viewGoalLeft = anchorRect.left + anchorRect.width/2 - viewWidth/2
        viewLeft = Math.max minLeft, viewGoalLeft

        view.css
          top: "#{ anchorRect.top + anchorRect.height + 10 }px"
          left: "#{ viewLeft }px"
          width: "#{ viewWidth }px"

        arrow.css
          left: "#{ anchorRect.left - viewLeft + anchorRect.width/2 }px"

      $scope.$on 'thPopover.dismiss', ->
        overlay.remove()
        view.remove()

      element.on 'click', ->
        view = angular.element template unless view?
        overlay = angular.element overlayTemplate unless overlay?
        arrow = view.find 'i'

        body = angular.element(document.body)
        body.append overlay
        body.append view

        overlay.on 'click', ->
          $scope.dismiss()

        $scope.$apply -> $compile(view)($scope)

      $scope.dismiss = ->
        $scope.$broadcast 'thPopover.dismiss'

      $scope.templateLoaded = ->
        $scope.$broadcast 'thPopover.templateLoaded'
