angular.module('ThemisComponents')
  .directive 'thRadioGroup', ->
    restrict: 'EA'
    replace: true
    bindToController: true
    controllerAs: "radioGroup"
    transclude: true
    template: """
        <div
          ng-class="{
            'th-radio-group': radioButtonSet.type == 'horizontal',
            'th-vertical-radio-group': radioButtonSet.type != 'horizontal'
          }"
          ng-transclude
          ></div>
    """
    scope:
      name: '@'
      type: '@'
      model: '=ngModel'
    controller: ($scope) ->
      return
