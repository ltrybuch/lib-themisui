$ = require 'jquery'
# require 'angular-sanitize'

angular.module('ThemisComponents', ['ui.select'])
  .directive 'thAutocomplete', ($compile, $timeout) ->
    restrict: 'E'
    scope:
    # #   name: '@'
      ngModel: '='
    # #   ngChange: '&'
    # #   fetchData: '='
      repeat: '@'
    # #   resultTemplate: '='
    #   selectionTemplate: '='
    transclude: true
    bindToController: true
    controllerAs: 'thAutocomplete'
    compile: (element, attrs) ->

      return post: (scope, element, attrs, controller) ->

        template = require './thAutocomplete.template.html'

        # The scope used for the table template will be a child of thTable's
        # scope that inherits from thTable's parent scope.
        #
        # This is so that the contents of <th-table-row>s have access to the
        # outside scope, as if they were transcluded.
        childScope = scope.$parent.$new false, scope

        # We are attaching the table's controller to the scope, so that the
        # template has access to it.
        childScope.thAutocomplete = scope.thAutocomplete

        compiledTemplate = $compile(template) childScope
        element.append compiledTemplate

    controller: ($scope, $element, $attrs) ->

      return
