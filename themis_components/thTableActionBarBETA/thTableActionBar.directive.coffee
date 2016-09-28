pluralize = require "pluralize"

angular.module("ThemisComponents")
  .directive "thTableActionBarBeta", ->
    restrict: "AE"
    scope:
      delegate: "="
      itemName: "@"
      buttonName: "@"
    transclude: true
    bindToController: true
    controllerAs: "actionBar"
    template: require "./thTableActionBar.template.html"
    controller: ($scope, $element, $attrs) ->

      @toggleAll = ->
        if @delegate.results.allSelected
          @delegate.results.actionBarModel.view.selected = yes
          @delegate.results.allSelected = yes
        else
          @delegate.triggerReset()

      @itemName ||= "item"
      itemName = @itemName.split " "
      @lastWord = itemName.splice(itemName.length - 1).toString()
      @openingWords = itemName.join " "

      @buttonName ||= "Apply"

      @pluralizeItemName = (count) -> return pluralize @itemName, count

      @triggerApply = ->
        @delegate.results.processing = yes
        @delegate.evaluateOnApplyFunction()

      return
