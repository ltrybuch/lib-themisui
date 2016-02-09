angular.module('ThemisComponents').directive "thTextarea", ->
  restrict: "E"
  bindToController: true
  controllerAs: 'ctrl'
  scope:
    placeholder: '@'
    name: '@'
    icon: '@'
    model: '=?ngModel'
    rows: '='
    ngRequired: '='
    ngDisabled: '='
    ngMinlength: '='
    ngMaxlength: '='
    ngPattern: '='
  template: require './thTextarea.template.html'
  controller: -> return
  link: (scope, element) ->
    # add box shadow on entire element when in focus
    element.find("textarea").on "focus", ->
      angular.element(@parentElement).addClass("has-focus")
    element.find("textarea").on "blur", ->
      angular.element(@parentElement).removeClass("has-focus")
    return
