class DisclosureContent
  ###@ngInject###
  constructor: ($element, $timeout, DisclosureManager, Utilities) ->
    @open = no
    @contentHeight = 0
    @_transitionTimeout = 300
    @_applyTransitionTimeout = 100
    @_disclosureManager = DisclosureManager
    @_$element = $element
    @_$timeout = $timeout
    @_utilities = Utilities

  $onInit: ->
    @_disclosureContent = @_$element[0].querySelector "ng-transclude"
    @_disclosureManager.registerDisclosureContent @name,
      handleOpen: =>
        @_animateToggle on

      handleClose: =>
        @_animateToggle off

  _animateToggle: (expanded) =>
    height = @_utilities.getElementActualHeight @_disclosureContent

    if expanded
      @_$timeout =>
        @contentHeight = height

        @_$timeout =>
          @open = yes
        , @_transitionTimeout
    else
      @_$timeout =>
        @open = no
        @contentHeight = height

        @_$timeout =>
          @contentHeight = 0
        , @_applyTransitionTimeout

angular.module "ThemisComponents"
  .component "thDisclosureContent",
    transclude: true
    bindings:
      name: "@"
    template: require "./thDisclosureContent.template.html"
    controllerAs: "thDisclosureContent"
    controller: DisclosureContent
