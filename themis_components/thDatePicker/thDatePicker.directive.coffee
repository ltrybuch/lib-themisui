moment = require("moment")

angular.module('ThemisComponents')
  .directive 'thDatePicker', ->
    restrict: "E"
    template: require "./thDatePicker.template.html"
    scope:
      date: "=ngModel"
      dateFormat: "@"
    bindToController: true
    controllerAs: 'datepicker'
    controller: ($element, $scope, $filter) ->
      @registerDateWatcher = =>
        @unregisterDateWatcher() if @unregisterDateWatcher?
        @unregisterDateWatcher = $scope.$watch 'datepicker.date', ->
          setInputDate()

      setInputDate = =>
        initDateFormat()
        @inputDate = @date.format(@dateFormat)

      initDateFormat = =>
        validDateFormats = [
          'YYYY-MM-DD'
          'MM/DD/YYYY'
          'DD/MM/YYYY'
        ]
        @dateFormat = validDateFormats[0] unless @dateFormat in validDateFormats

      initDateFormat()
      @date = moment() if !@date
      @inputDate = ""
      @unregisterDateWatcher = null

      $scope.$watch 'datepicker.inputDate', =>
        parsedDate = moment(@inputDate, @dateFormat)
        if parsedDate.isValid()
          @date = parsedDate

      @registerDateWatcher()

      dateInputField = $element.find('input')
      
      dateInputField.on 'blur', => $scope.$apply =>
        @registerDateWatcher()
        setInputDate()

      dateInputField.on 'focus', => $scope.$apply =>
        @unregisterDateWatcher()

      return
