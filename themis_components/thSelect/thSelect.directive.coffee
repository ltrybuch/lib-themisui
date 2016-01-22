container = (template) ->  """
  <div class="select-wrapper">
    #{template}
    <div class="text-wrapper"
      ng-class="{disabled: select.ngDisabled}">
      <span class="selected-text">
        {{select.selectedText}}
      </span>
      <i class="fa fa-caret-down"></i>
    </div>
  </div>
"""

selectTemplate = require './thSelect.select.template.html'
transcludeTemplate = require './thSelect.transclude.template.html'

angular.module('ThemisComponents')
  .directive "thSelect", ($filter) ->
    restrict: "EA"
    template: (element, attrs) ->
      if attrs.options?
        container(selectTemplate)
      else
        container(transcludeTemplate)
    controllerAs: "select"
    replace: true
    bindToController: true
    transclude: true
    scope:
      options: "="
      ngModel: "="
      name: "@"
      ngDisabled: "="
      ngChange: "&"
      ngRequired: "="

    controller: ($scope, $element) ->
      @selectedText = @ngModel?.name ? "choose..."
      @placeholderOption = @options[0] if @options?[0].value is ""

      if @placeholderOption?
        begin = 1 - @options.length
        @options = $filter('limitTo')(@options, begin)

      return

    link: (scope, element, attributes, controller) ->
      updateSelectText = (text) ->
        el = element[0].getElementsByClassName("selected-text")
        el[0].textContent = text

      # On the change event, update the select's text
      element.on 'change', (event) ->
        text = event.target.selectedOptions[0].text
        updateSelectText text

      # On the model change, update the select's text
      scope.$watch ->
        controller.ngModel
      , (newValue) ->
        if newValue?
          updateSelectText newValue.name

      # Grab the initially selected option and add its name to our
      # styled replacement select. This will only be applicable
      # if we are not passing in an array of options.
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
