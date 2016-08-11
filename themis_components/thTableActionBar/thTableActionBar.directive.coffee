pluralize = require('pluralize')

angular.module('ThemisComponents')
  .directive 'thTableActionBar', ->
    restrict: "AE"
    scope:
      delegate: "="
      itemName: "@"
      buttonName: "@"
    transclude: true
    bindToController: true
    controllerAs: 'actionBar'
    template: require './thTableActionBar.template.html'
    controller: ($scope, $element, $attrs) ->
      @itemName ||= "item"
      @buttonName ||= "Apply"

      @pluralizeItemName = (count) -> return pluralize @itemName, count

      @triggerApply = ->
        @delegate.results.processing = yes
        @delegate.evaluateOnApplyFunction()

      @toggleAll = ->
        $scope.$apply =>
          if @delegate.results.isCurrentPageSelected
            @delegate.selectPage()
          else
            @delegate.clearPage()

      @selectEntirety = -> @delegate.selectEntireCollection()

      @clearEntirety = -> @delegate.clearEntireCollection()

      @hasMultiplePages = ->
        @delegate.results.totalItemCount > @delegate.results.pageSize

      return
