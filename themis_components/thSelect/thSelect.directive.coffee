selectTemplate = """
  <div>
  <select ng-transclude></select>
  <div class="th-select-wrapper">
    <div class="selected-text">
      {{select.selected}}
      <i class="fa fa-caret-down"></i>
    </div>
  </div>
  </div>
"""
angular.module('ThemisComponents')
  .directive "thSelect", ->
    restrict: "EA"
    template: selectTemplate
    controllerAs: "select"
    replace: true
    bindToController: true
    transclude: true
    scope:
      options: "="
    controller: ->
      @options = [] ? @options
      @selected = "Select one..."
      @open = no
      @toggle = ->
        @open = !@open
      @setSelected = (option) ->
        # @selected = option if option.selected
      return
    link: (scope, element) ->
      debugger
      # add box shadow on entire element when in focus
      element.find("select").on "focus", ->
        angular.element(this.parentElement).addClass("has-focus")
      element.find("select").on "blur", ->
        angular.element(this.parentElement).removeClass("has-focus")
      return

