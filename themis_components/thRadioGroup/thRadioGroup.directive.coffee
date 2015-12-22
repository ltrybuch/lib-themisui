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
    controller: ($scope, $attrs) ->
      buttons = []

      @addButton = (button, checked) ->
        # Compare to ng-model by default; otherwise 'checked' attribute
        button.checked = if $attrs['ngModel']? then @value == button.value else checked
        buttons.push button

      @selectButton = (buttonToSelect) ->
        if not buttonToSelect.checked
          # Update ng-model
          $scope.$apply =>
            @value = buttonToSelect.value if $attrs['ngModel']?

          # Evaluate ng-change expression on group
          @change() if @change?

          # Evaluate ng-change expression on last checked button
          button.change() for button in buttons when button.checked is true

          # Evaluate ng-change expression on selected button
          buttonToSelect.change()

          # Update internal button state
          $scope.$apply ->
            buttonToSelect.checked = yes
            button.checked = no for button in buttons when button isnt buttonToSelect

      return
