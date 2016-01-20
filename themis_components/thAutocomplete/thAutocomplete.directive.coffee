$ = require 'jquery'
require 'select2'

angular.module('ThemisComponents')
  .directive 'thAutocomplete', ($timeout) ->
    restrict: 'E'
    scope:
      delegate: '='
      ngModel: '='
      ngChange: '&'
    transclude: true
    template: require './thAutocomplete.template.html'
    bindToController: true
    controllerAs: 'thAutocomplete'
    controller: ($scope, $element) ->
      $select = $ $element.find('select')[0]


      $timeout =>
        $select.select2
          placeholder: 'this is a test'
        .val(@ngModel).trigger('change')



      $select.on 'change', =>
        $timeout =>
          $scope.$apply =>
            @ngModel = $select.val()

          # Evaluate ng-change expression
          @ngChange() if @ngChange?
      return
    link: (scope, element, attrs, controller, transcludeFn) ->
      delegate = controller.delegate

      # $(element.find('select')).select2
      #   placeholder: 'this is a test'
      # .val(controller.ngModel).trigger('change')



      

      # $(element[0]).select2
      #   ajax:
      #     data: (params) ->
      #       {
      #         term
      #       } = params
      #     transport: (params, success, failure) ->
      #       delegate.fetchData params.data, (data) ->
      #         success({
      #           results: data
      #         })

      return
