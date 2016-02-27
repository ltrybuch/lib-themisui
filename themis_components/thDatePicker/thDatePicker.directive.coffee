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
      
      # init date model to today or a valid moment
      @ngModel = moment() unless @ngModel.isValid()

      setDateFormat = =>
        validDateFormats = ['YYYY-MM-DD', 'MM/DD/YYYY', 'DD/MM/YYYY']
        defaultDateFormat = validDateFormats[0]
        if @dateFormat in validDateFormats then @dateFormat else defaultDateFormat

      @dateFormat = setDateFormat()

      # init input field date view
      @viewDate = ""

      setViewDate = =>
        @viewDate = @ngModel.format(@dateFormat)

      @registerModelWatcher = =>
        @unregisterModelWatcher() if @unregisterModelWatcher?
        @unregisterModelWatcher = $scope.$watch 'controller.ngModel', ->
          setViewDate('model watch')

      $scope.$watch 'controller.viewDate', =>
        parsedDate = moment @viewDate, @dateFormat
        @ngModel = parsedDate if parsedDate.isValid()

      @registerModelWatcher()

      # on blur on input we'll set the model
      dateInputField = $element.find('input')
      dateInputField.on 'blur', => $scope.$apply =>
        @registerModelWatcher()
        setViewDate('onblur')

      # on focus on input we'll unregister our listener
      dateInputField.on 'focus', => $scope.$apply =>
        @unregisterModelWatcher()

      return
