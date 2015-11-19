template = """
  <div class="th-loader" ng-show="loader.visible">
    <div class="progress {{loader.size}}"><div>Loading…</div></div>
    <p class="loading-text" ng-transclude></p>
  </div>
"""

angular.module('ThemisComponents')
  .directive "thLoader", ->
    restrict: "EA"
    template: template
    transclude: true
    replace: true
    controllerAs: 'loader'
    scope: true
    bindToController:
      visible: "=trigger"
      promise: "="
      timeout: "="
      size: "@"

    link: (scope, element, attrs) ->
      messageElement = element[0].querySelector(".loading-text")

      # replace a blank message with default message
      if messageElement.innerText == ""
        messageElement.innerText = "Loading..."

    controller: ($timeout) ->
      @visible = @visible ? yes

      switch
        # if millisecs is passed
        when @timeout?
          $timeout =>
            @visible = no
          , @timeout

        # if promise is passed
        when @promise?
          @promise.finally =>
            @visible = no

      return


