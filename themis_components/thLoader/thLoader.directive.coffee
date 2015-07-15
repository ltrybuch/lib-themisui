angular.module('ThemisComponents')
  .directive "thLoader", ->
    restrict: "EA"
    replace: true
    scope:
      loadingText: '=?'
    controllerAs: 'loader'
    bindToController: true
    controller: ->
      @text = @loadingText ? "Loading..."
      return
    template: """
      <div class="th-loader">
        <div class="sk-spinner sk-spinner-three-bounce">
          <div class="sk-bounce1"></div>
          <div class="sk-bounce2"></div>
          <div class="sk-bounce3"></div>
        </div>
        <p class="loading-text">{{loader.text}}</p>
      </div>
    """