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
      @dateFormat = @dateFormat || 'y-MM-d'
      console.log('date:' + @date)
      #@date = $filter('date')(@date, @dateFormat)
      
      return
    # link: (scope, element, attrs, ngModelCtrl) ->
    #   return unless ngModelCtrl?

    #   ngModelCtrl.$parsers.push (value) ->
    #     # value = if (! isDate)
    #     console.log('parsers ' + value)
    #     return value 

    #   ngModelCtrl.$formatters.push (value) ->
    #     console.log('formatter ' + value)
    #     return value 



