$ = require 'jquery'
require 'select2'

angular.module('ThemisComponents')
  .directive 'thAutocomplete', ($timeout) ->
    restrict: 'E'
    scope:
      delegate: '='
      ngModel: '='
      ngChange: '&'
      options: '='
    transclude: true
    template: require './thAutocomplete.template.html'
    bindToController: true
    controllerAs: 'thAutocomplete'
    controller: ($scope, $element) ->
      $select = $ $element.find('select')[0]


      # $timeout =>
      #   $select.select2
      #     placeholder: 'this is a test'
      #   .val(@ngModel).trigger('change')



      $select.on 'change', =>
        $timeout =>
          $scope.$apply =>
            @ngModel = $select.val()

          # Evaluate ng-change expression
          @ngChange() if @ngChange?
      return
    link: (scope, element, attrs, controller) ->
      { placeholder, fetchData } = controller.options

      options = { placeholder }
      ajaxOption = if fetchData instanceof Function then {
        ajax:
          data: (params) ->
            {
              term
            } = params
          transport: (params, success, failure) ->
            fetchData params.data, (data) ->
              success({
                results: data
              })
      } else {}
      angular.extend(options, ajaxOption)

      $select = $ element.find 'select'
      $select.select2(options).val(controller.ngModel).trigger('change')

      return
