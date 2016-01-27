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
  .directive "thSelect", ($timeout) ->
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
      placeholder: "@"

    controller: ($scope, $element) ->
      @selectedText = @placeholder
      @selectedText = @ngModel.name if @ngModel?
      return

    link: (scope, element, attributes, controller) ->
      # With a transcluded template we'll set the visible text with on change
      # events. Initial text is set with the `selected` option's text.
      usingTranscludedTemplate = !attributes.options?

      updateSelectText = (text = "") ->
        $timeout ->
          scope.$apply -> controller.selectedText = text

      # On the change event, update the select's text
      if usingTranscludedTemplate
        element.on 'change', (event) ->
          text = event.target.selectedOptions[0].text
          updateSelectText text

      # On the model change, update the select's text
      scope.$watch ->
        controller.ngModel
      , (newValue) ->
        text = newValue?.name ? controller.placeholder
        controller.selectedText = text

      # Grab the initially selected option and add its name to our
      # styled replacement select. This will only be applicable
      # if we are not passing in an array of options.
      if usingTranscludedTemplate
        counter = 0
        options = element.find "option"
        for option in options when option.hasAttribute "selected"
          updateSelectText option.text
          counter++

        if counter > 1
          console.warn(
            "#{counter} options are set on a non-multiple select \
            (name: #{attributes.name}). The last selected option will be used."
          )

      # add box shadow on entire element when in focus
      select = element.find "select"
      select.on "focus", ->
        angular.element(this).next().addClass "has-focus"
      select.on "blur", ->
        angular.element(this).next().removeClass "has-focus"

      return
