angular.module('ThemisComponents').directive "thTextarea", ->
  restrict: "E"
  bindToController: true
  controllerAs: 'ctrl'
  replace: true
  scope:
    type: '@'
    name: '@'
    value: '@'
    icon: '@'
    prefix: '@'
    model: '=?ngModel'
  template: require './thTextarea.template.html'
  controller: ($attrs) ->
    @placeholder = $attrs.placeholder

  link: (scope, element) ->
    # add box shadow on entire element when in focus
    element.find("input").on "focus", ->
      angular.element(@parentElement).addClass("has-focus")
    element.find("input").on "blur", ->
      angular.element(@parentElement).removeClass("has-focus")
    return
