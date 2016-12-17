class ActionBarController
  ###@ngInject###

  constructor: (@$scope) -> @checked = no

  $onInit: -> @_setUpWatch()

  _setUpWatch: ->
    @$scope.$watch (=> @delegate.results.allSelected), (newValue) =>
      @checked = newValue

  toggleAll: ->
    @$scope.$apply =>
      @delegate.toggleAll @checked

  triggerApply: ->
    @delegate.triggerApply @selectedAction

angular.module('ThemisComponents')
  .component "thActionBar",
    template: require './thActionBar.template.html'
    transclude: true
    bindings:
      delegate: "=?"
    controller: ActionBarController
