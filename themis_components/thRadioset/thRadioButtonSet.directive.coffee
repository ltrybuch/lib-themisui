angular.module('ThemisComponents')
  .directive 'thRadioButtonSet', ->
    restrict: 'EA'
    replace: true
    bindToController: true
    controllerAs: "radioButtonSet"
    transclude: true
    template: """
      <div>
        {{radioButtonSet.name}}
        <div ng-transclude></div>
      </div>
    """
    scope:
      name: '@'
      model: '=ngModel'
    controller: ->
      return
