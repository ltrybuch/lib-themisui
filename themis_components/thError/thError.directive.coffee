angular.module("ThemisComponents")
  .directive "thError", ->
    restrict: "E"
    transclude: true
    template: """
      <div class="th-error-container">
        <i class="fa fa-exclamation-triangle"></i>
        <span class="th-error-message" ng-if="!ctrl.message">
          We had trouble loading your content.<br>Try reloading the page.
        </span>
        <ng-transclude ng-if="ctrl.message"></ng-transclude>
      </div>
    """
    scope:
      message: "@"
    controllerAs: "ctrl"
    bindToController: true
    controller: -> return
    link: (scope, elm, attr, ctrl, $transclude) ->
      $transclude (clone) ->
        scope.ctrl.message = true if clone.length
