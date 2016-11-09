class ModalTitlebar
  constructor: ($element, $scope) ->
    "ngInject"
    @type ?= "standard"
    @showCloseButton ?= true

    $element.addClass "type-#{@type}"

  close = ->
    if $scope.$parent.modal?
      $scope.$parent.modal.dismiss()

angular.module('ThemisComponents')
  .component 'thModalTitlebar',
    template: require "./thModalTitlebar.template.html"
    controller: ModalTitlebar
    bindings:
      title: "@"
      type: "@"
      showCloseButton: "<"
