$ = require 'jquery'
require 'select2'

angular.module('ThemisComponents')
  .directive 'thAutocomplete', ($timeout) ->
    restrict: 'E'
    scope:
      name: '@'
      ngModel: '='
      ngChange: '&'
      fetchData: '='
      placeholder: '@'
      resultTemplate: '='
      selectionTemplate: '='
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
        escapeMarkup: (m) ->
          return m
      }

      ajaxOption = {}
      resultTemplateOption = {}
      selectionTemplateOption = {}

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

      resultTemplateOption = if controller.resultTemplate instanceof Function then {
        templateResult: (item) ->
          if item.loading
            return item.text
          else
            controller.resultTemplate(item)
      } else {}

      selectionTemplateOption = if controller.selectionTemplate instanceof Function then {
        templateSelection: (item) ->
          if item.id.length > 0
            return controller.selectionTemplate(item)
          else
            return item.text
      } else {}

      angular.extend(options, ajaxOption)
      angular.extend(options, resultTemplateOption)
      angular.extend(options, selectionTemplateOption)

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
