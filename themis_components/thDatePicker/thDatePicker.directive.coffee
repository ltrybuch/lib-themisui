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
    controller: ($element, $scope, $attrs) ->
      
      #set our model
      @ngModel = moment() unless @ngModel.isValid()

      # initialize our format
      validDateFormats = ['YYYY-MM-DD', 'MM/DD/YYYY', 'DD/MM/YYYY']
      if @dateFormat in validDateFormats
        @viewFormat = @dateFormat
      else @viewFormat = validDateFormats[0]

      #initialize view date
      @viewDate = ""

      setInternalDate = =>
        @viewDate = @ngModel.format(@viewFormat)

      @registerModelWatcher = =>
        @unregisterModelWatcher() if @unregisterModelWatcher?
        @unregisterModelWatcher = $scope.$watch 'controller.ngModel', ->
          setInternalDate()

      $scope.$watch 'controller.viewDate', =>
        parsedDate = moment @viewDate, @viewFormat
        @ngModel = parsedDate if parsedDate.isValid()

      @registerModelWatcher()

      # on blur on input we'll set the model
      dateInputField = $element.find('input')
      dateInputField.on 'blur', => $scope.$apply =>
        @registerModelWatcher()
        setInternalDate()

      # on focus on input we'll unregister our listener
      dateInputField.on 'focus', => $scope.$apply =>
        @unregisterModelWatcher()

      return
