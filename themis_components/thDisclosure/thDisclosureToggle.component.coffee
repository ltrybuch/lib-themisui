class DisclosureToggle
  ###@ngInject###
  constructor: ($timeout, DisclosureManager) ->
    @_$timeout = $timeout
    @_DisclosureManager = DisclosureManager

  $onInit: ->
    @textSide ?= "left"
    @expanded ?= false

    @_DisclosureManager.registerDisclosureToggle @name,
      handleOpen: =>
        @expanded = true

      handleClose: =>
        @expanded = false

    @_$timeout =>
      @_DisclosureManager.updateState @name, @expanded

  toggle: =>
    unless @ngDisabled
      @_DisclosureManager.updateState @name, not @expanded

angular.module 'ThemisComponents'
  .component 'thDisclosureToggle',
    transclude: true
    bindings:
      name: '@'
      expanded: '=?'
      ngDisabled: '=?'
      textSide: '@'
    template: require './thDisclosureToggle.template.html'
    controllerAs: 'thDisclosureToggle'
    controller: DisclosureToggle
