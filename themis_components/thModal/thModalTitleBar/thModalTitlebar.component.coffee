thModalTitlebar = ($element, $scope) ->
  @type ?= "standard"

  $element.addClass "type-#{@type}"

  @close = ->
    if $scope.$parent.modal?
      $scope.$parent.modal.dismiss()

  return

angular.module('ThemisComponents')
  .component 'thModalTitlebar',
    template: require "./thModalTitlebar.template.html"
    controller: thModalTitlebar
    bindings:
      title: "@"
      type: "@"
