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
  link: (scope, element, attr) ->
    textarea = element.find "textarea"

    textarea.css "resize", "none" if attr.expandable is "false"

    # Pass non Angular classes to the textarea element.
    angularClass = /(^ng-)/
    for className in element[0].classList
      if !angularClass.test className
        textarea.addClass className
        element.removeClass className

    # add box shadow on entire element when in focus
    textarea.on "focus", ->
      angular.element(@parentElement).addClass("has-focus")
    textarea.on "blur", ->
      angular.element(@parentElement).removeClass("has-focus")
    return
