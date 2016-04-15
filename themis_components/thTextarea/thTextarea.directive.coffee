angular.module('ThemisComponents').directive "thTextarea", ->
  restrict: "E"
  bindToController: true
  controllerAs: 'ctrl'
  require: ["?^form", "thTextarea"]
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

  link: (scope, element, attribute, controllerArray) ->
    form = controllerArray[0] ? null
    controller = controllerArray[1]
    fieldName = controller.name ? null

    # If input value is invalid append invalid class.
    controller.isInvalid = ->
      return no unless fieldName and form
      form[fieldName].$invalid && (form[fieldName].$touched or form.$submitted)

    textarea = element.find "textarea"
    textarea.css "resize", "none" if attribute.expandable is "false"

    # Pass non Angular classes to the textarea element.
    angularClass = /(^ng-)/
    for className in element[0].classList
      if !angularClass.test className
        textarea.addClass className
        element.removeClass className

    # Toggle box-shadow.
    textarea.on "focus", -> textarea.addClass "has-focus"
    textarea.on "blur", -> textarea.removeClass "has-focus"
    return
