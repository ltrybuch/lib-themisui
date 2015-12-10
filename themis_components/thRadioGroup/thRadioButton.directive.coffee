angular.module('ThemisComponents')
  .directive "thRadioButton", ->
    require: '^thRadioGroup'
    restrict: "EA"
    replace: true

    template: """
      <span class="th-radio-button">
        <input
          type="radio"
          name="{{parent.name}}"
          value="{{value}}"
          ng-model="parent.model"
          >
        <i
          ng-class="{
            checked: parent.model == value
            }"
          ></i>
      </span>
    """

    scope:
      value: '@'

    link: (scope, element, attrs, controller) ->
      scope.parent = controller

      element.on 'click', ->
        scope.$apply ->
          scope.parent.model = scope.value

      return
