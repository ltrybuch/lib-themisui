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
      #set our model
      @ngModel = moment() unless @ngModel.isValid()

      # initialize our format
      validDateFormats = ['YYYY-MM-DD', 'MM/DD/YYYY', 'DD/MM/YYYY']
      @dateFormat = validDateFormats[0] unless @dateFormat in validDateFormats

      #initialize internal date
      @internalDate = ""

      setInternalDate = =>
        validDateFormats = ['YYYY-MM-DD', 'MM/DD/YYYY', 'DD/MM/YYYY']
        @dateFormat = validDateFormats[0] unless @dateFormat in validDateFormats
        @internalDate = @ngModel.format(@dateFormat)

      # @unregisterModelWatcher = null

      @registerModelWatcher = =>
        @unregisterModelWatcher() if @unregisterModelWatcher?
        @unregisterModelWatcher = $scope.$watch 'controller.ngModel', ->
          setInternalDate()

      $scope.$watch 'controller.internalDate', =>
        parsedDate = moment @internalDate, @dateFormat
        @ngModel = parsedDate if parsedDate.isValid()

      @registerModelWatcher()

      # on blur on input we'll set the model
      dateInputField = $element.find('input')
      dateInputField.on 'blur', =>
        @registerModelWatcher()
        setInternalDate()

      # on focus on input we'll unregister our listener
      dateInputField.on 'focus', =>
        @unregisterModelWatcher()

      return
