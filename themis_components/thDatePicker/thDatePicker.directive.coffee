moment = require "moment"

angular.module('ThemisComponents')
  .directive 'thDatePicker', ->
    restrict: "E"
    template: require "./thDatePicker.template.html"
    scope:
      ngModel: "="
      dateFormat: "@"
    bindToController: true
    controllerAs: 'controller'
    controller: ($element, $scope) ->

      # Initialize the model to today if it isn't a valid moment.
      @ngModel = moment() unless @ngModel.isValid()

      setDateFormat = =>
        validDateFormats = ['YYYY-MM-DD', 'MM/DD/YYYY', 'DD/MM/YYYY']
        defaultDateFormat = validDateFormats[0]
        if @dateFormat in validDateFormats then @dateFormat else defaultDateFormat

      @dateFormat = setDateFormat()

      # Initialize the input field string
      @inputFieldString = ""

      setInputFieldString = =>
        @inputFieldString = @ngModel.format(@dateFormat)

      # When the datepicker changes the model, update the input field string
      @registerModelWatcher = =>
        @unregisterModelWatcher() if @unregisterModelWatcher?
        @unregisterModelWatcher = $scope.$watch 'controller.ngModel', ->
          setInputFieldString()

      # update the model and datepicker unless the user enters an invalid date
      $scope.$watch 'controller.inputFieldString', =>
        parsedDate = moment @inputFieldString, @dateFormat
        @ngModel = parsedDate if parsedDate.isValid()

      @registerModelWatcher()

      # On blur of the input field
      dateInputField = $element.find('input')
      dateInputField.on 'blur', => $scope.$apply =>
        # listen for datepicker model changes
        @registerModelWatcher()

      # On focus of the input field, unregister our model listener
      dateInputField.on 'focus', => $scope.$apply =>
        @unregisterModelWatcher()

      return
