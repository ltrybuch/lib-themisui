pluralize = require "pluralize"

angular.module("ThemisComponents")
  .directive "thActionBarBilling", ->
    restrict: "AE"
    scope:
      delegate: "="
      itemName: "@"
      buttonName: "@"
    transclude: true
    bindToController: true
    controllerAs: "actionBar"
    template: require "./thActionBarBilling.template.html"
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

      @isIndeterminate = ->
        @delegate.results.selectedItemCount > 0 and !@delegate.results.allSelected

      @pluralizeItemName = (count) -> return pluralize @itemName, count

      @triggerApply = ->
        @delegate.results.processing = yes
        @delegate.evaluateOnApplyFunction()

      return
