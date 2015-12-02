template = (select) ->  """
  <div class="select-wrapper">
    #{select}
    <div class="selected-text">
      {{select.selectedText}}
      <i class="fa fa-caret-down"></i>
    </div>
  </div>
"""

selectTemplate = require './thSelect.select.template.html'
transcludeTemplate = require './thSelect.transclude.template.html'

angular.module('ThemisComponents')
  .directive "thSelect", ->
    restrict: "EA"
    template: (element, attrs) ->
      if attrs.options?
        template(selectTemplate)
      else
        template(transcludeTemplate)
    controllerAs: "select"
    replace: true
    bindToController: true
    transclude: true
    scope:
      options: "="
      ngModel: "="
      name: "@"
      disabled: "@"
      ngChange: "=?"

    controller: ($scope, $element) ->
      @selectedText = @ngModel?.name ? "Choose…"

      $element.find("select").on 'click', (event) -> undefined
      # when a new option is selected we want to capture the name
      # and add it to our styled select replacement.
      $element.on 'change', (event) =>
        $scope.$apply =>
          @selectedText = event.target.selectedOptions[0].text
      return

    link: (scope, element, attributes) ->
      # grab the initially selected option and add
      # it's name to our styled replacement select
      # this will only be applicable to if we are not
      # passing in an array of options so we check for that first.
      options = element.find "option"
      unless attributes.options?
        counter = 0
        for option in options when option.hasAttribute "selected"
          scope.select.selectedText = option.text
          counter++
        if counter > 1
          console.warn(
            "#{counter} options are set on a non-multiple select (name: #{attributes.name}).
             The last selected option will be used."
          )

      # add box shadow on entire element when in focus
      select = element.find "select"
      select.on "focus", ->
        angular.element(this).next().addClass "has-focus"
      select.on "blur", ->
        angular.element(this).next().removeClass "has-focus"
      return
