angular.module('ThemisComponents').directive "thInput", ->
  restrict: "E"
  bindToController: true
  controllerAs: 'input'
  replace: true
  scope:
    type: '@'
    name: '@'
    value: '@'
    icon: '@'
    prefix: '@'
    postfix: '@'
    ngModel: '='
    ngRequired: '='
    ngDisabled: '='
    ngMinlength: '='
    ngMaxlength: '='
    ngPattern: '='

  template: require './thInput.template.html'
  controller: ($attrs) ->
    @placeholder = $attrs.placeholder

  link: (scope, element) ->
    # add box shadow on entire element when in focus
    element.find("input").on "focus", ->
      angular.element(@parentElement).addClass("has-focus")
    element.find("input").on "blur", ->
      angular.element(@parentElement).removeClass("has-focus")
    return
