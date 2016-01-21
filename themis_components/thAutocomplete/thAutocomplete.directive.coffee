$ = require 'jquery'
require 'select2'

angular.module('ThemisComponents')
  .directive 'thAutocomplete', ($timeout) ->
    restrict: 'E'
    scope:
      name: '@'
      delegate: '='
      ngModel: '='
      ngChange: '&'
      options: '='
      fetchData: '='
      placeholder: '@'
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

      return
    link: (scope, element, attrs, controller) ->
      options = {
        placeholder: controller.placeholder
      }

      ajaxOption = if controller.fetchData instanceof Function then {
        minimumInputLength: 1
        ajax:
          delay: 250
          data: (params) ->
            {
              term
            } = params
          transport: (params, success, failure) ->
            controller.fetchData params.data, (data) ->
              success({
                results: data
              })
      } else {}
      angular.extend(options, ajaxOption)

      $select = $ element.find 'select'
      $select.select2(options)

      hasNgModel = attrs.ngModel != undefined
      if hasNgModel
        # To set the initial value we need to make sure any
        # transcluded content is already compiled, so options
        # from ng-repeat are available to select2
        $timeout ->
          $select.val(controller.ngModel).trigger('change')
        
          $select.on 'change', ->
            $timeout ->
              scope.$apply ->
                controller.ngModel = $select.val()

              # Evaluate ng-change expression
              controller.ngChange() if controller.ngChange?

      return
