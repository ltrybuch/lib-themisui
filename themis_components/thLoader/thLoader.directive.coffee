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
      defaultMessage = "Loading..."
      msgElement = element.find("span")
      # check to see if a message is passed in
      if msgElement.length > 0 then message = msgElement[0].innerHTML

      # add our default if needed
      if !message then element.find("p").replaceWith(
        "<p class='loading-text'>#{defaultMessage}</p>")

    controller: ($timeout) ->
      @visible = @visible ? yes

      startTimer = =>
        $timeout =>
          @visible = no
        , parseInt @timeout

      switch
        # if millisecs is passed
        when @timeout?
          startTimer()

        # if promise is passed
        when @promise?
          @promise.finally =>
            @visible = no
      return


