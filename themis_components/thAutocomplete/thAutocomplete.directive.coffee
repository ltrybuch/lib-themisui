$ = require 'jquery'
require 'select2'

angular.module('ThemisComponents')
  .directive 'thAutocomplete', ->
    restrict: 'E'
    scope:
      delegate: '='
      ngModel: '='
    replace: true
    template: require './thAutocomplete.template.html'
    bindToController: true
    controllerAs: 'thAutocomplete'
    transclude: true
    controller: ($scope, $element, $timeout) ->
      $($element[0]).on 'change', (event) =>
        $timeout =>
          @ngModel = $element.val()

      return
    link: (scope, element, attrs, controller) ->
      delegate = controller.delegate

      $(element[0]).select2
        ajax:
          data: (params) ->
            {
              term
            } = params
          transport: (params, success, failure) ->
            delegate.fetchData params.data, (data) ->
              success({
                results: data
              })

      return
