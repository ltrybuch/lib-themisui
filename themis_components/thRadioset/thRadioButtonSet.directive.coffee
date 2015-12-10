angular.module('ThemisComponents')
  .directive 'thRadioButtonSet', ->
    restrict: 'EA'
    replace: true
    bindToController: true
    controllerAs: "radioButtonSet"
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
