angular.module('ThemisComponents')
  .directive "thLoader", ->
    restrict: "EA"
    template: require './thLoader.template.html'
    transclude: true
    replace: true
    controllerAs: 'loader'
    scope:
      visible: "=?trigger"
      promise: "="
      timeout: "="
      size: "@"
      theme: "="
    bindToController: true

    link: (scope, element, attrs) ->
      # replace a blank message with default message
      messageElement = element[0].querySelector(".loading-text")
      messageElement.innerText ||= "Loading..."

    controller: ($timeout) ->
      @visible ||= yes

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
