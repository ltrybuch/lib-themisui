angular.module('ThemisComponents')
  .directive 'thDatePicker',  ->
    restrict: "E"
    template: require "./thDatePicker.template.html"
    scope:
      date: "=ngModel"
      dateFormat: "@"
    bindToController: true
    controllerAs: 'datepicker'
    controller: ($scope, $filter) ->
      @dateFormat = @dateFormat || 'yyyy-MM-dd'

      @date = $filter('date')(@date, @dateFormat)
      return
