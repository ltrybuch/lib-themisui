angular.module('ThemisComponents').directive "thInput", ->
  restrict: "EA"
  bindToController: true
  controllerAs: 'input'
  replace: true
  require: ["?^form", "thInput"]
  scope:
    type: '@'
    name: '@'
    value: '@'
    icon: '@'
    prefix: '@'
    postfix: '@'
    placeholder: '@'
    condensed: "="
    ngModel: '='
    ngRequired: '='
    ngDisabled: '='
    ngKeypress: '&'
    ngMinlength: '='
    ngMaxlength: '='
    ngPattern: '='
    min: '='
    max: '='
    step: '='
  template: require './thInput.template.html'
  controller: -> return
  link: (scope, element, attribute, controllerArray) ->
    form = controllerArray[0] ? null
    controller = controllerArray[1]
    fieldName = controller.name ? null

    # If input value is invalid append invalid class.
    controller.isInvalid = ->
      return no unless fieldName and form
      form[fieldName].$invalid && (form[fieldName].$touched or form.$submitted)

    # Toggle box-shadow.
    input = element.find("input")
    input.on "focus", -> element.addClass("has-focus")
    input.on "blur", -> element.removeClass("has-focus")
    return
