angular.module('ThemisComponents')
  .directive 'thRadioGroup', ->
    restrict: 'EA'
    replace: true
    transclude: true
    bindToController: true
    controllerAs: 'radioGroup'
    template: require './thRadioGroup.template.html'
    scope:
      name: '@'
      change: '&ngChange'
      value: '=ngModel'
    controller: ($scope) ->
      selectedButton = null

      @selectButton = (button) ->
        if @value != button.value
          lastSelectedButton = selectedButton
          selectedButton = button

          $scope.$apply =>
            @value = selectedButton.value

          # Evaluate ng-change expression on group
          @change() if @change?
          # Evaluate ng-change expression on last selected button
          lastSelectedButton.change() if lastSelectedButton and lastSelectedButton.change?
          # Evaluate ng-change expression on selected button
          selectedButton.change() if selectedButton and selectedButton.change?

      return
