template = """
  <div class="th-loader" ng-show="loader.visible">
    <div class="sk-spinner sk-spinner-three-bounce">
      <div class="sk-bounce1"></div>
      <div class="sk-bounce2"></div>
      <div class="sk-bounce3"></div>
    </div>
    <p class="loading-text" ng-transclude>
    </p>
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

    link: (scope, element) ->
      messageEl = element[0].querySelector(".loading-text")

      # replace a blank message with default message
      if messageEl.innerHTML == ""
        messageEl.innerHTML = "Loading..."

    controller: ($timeout) ->
      @visible = @visible ? yes

      switch
        # if millisecs is passed
        when @timeout?
          $timeout => @visible = no, @timeout

        # if promise is passed
        when @promise?
          @promise.finally =>
            @visible = no
      return


