angular.module('ThemisComponents')
  .directive "thRadioButton", ->
    require: '^thRadioButtonSet'
    restrict: "EA"
    replace: true

    template: """
      <div class="th-radio-button">
        <input
          type="radio"
          name="{{parent.name}}"
          value="{{value}}"
          ng-model="parent.model"
          >
        <i ng-class="{checked: {{parent.model == value}}}"></i>
      </div>
    """

    scope:
      value: '@'

    link: (scope, element, attrs, controller) ->
      scope.parent = controller

      element.on 'click', =>
        scope.$apply =>
          controller.model = scope.value

      return
