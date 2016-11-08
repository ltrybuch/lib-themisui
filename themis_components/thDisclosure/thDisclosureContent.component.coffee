class DisclosureContent
  constructor: ($element, $timeout, DisclosureManager, Utilities) ->
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
    if expanded
      height = @_utilities.getElementActualHeight @_disclosureContent
      @_$timeout =>
        @contentHeight = height
    else
      @contentHeight = 0

DisclosureContent.$inject = ["$element", "$timeout", "DisclosureManager", "Utilities"]

angular.module "ThemisComponents"
  .component "thDisclosureContent",
    transclude: true
    bindings:
      name: "@"
    template: require "./thDisclosureContent.template.html"
    controllerAs: "thDisclosureContent"
    controller: DisclosureContent
