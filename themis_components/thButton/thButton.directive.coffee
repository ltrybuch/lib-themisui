angular.module('ThemisComponents')
  .directive "thButton", ->
    restrict: "EA"
    scope:
      type: '@'
      href: '@'
      loading: '=?'
    replace: true
    transclude: true
    template: (element, attrs) ->
      switch
        when attrs.href?
          require './thButton.anchor.template.html'
        else
          require './thButton.button.template.html'
    bindToController: true
    controllerAs: 'button'
    controller: ($scope, $element, $attrs, $transclude) ->
      @loading ||= no

      types = ["standard", "create", "destroy"]
      @theme = if @type?.toLowerCase() in types then "light" else "dark"

      # In HTML5 a button with no type attribute is 'submit' by default.
      # If not used for submit, must explicitly specify 'button'.
      isSubmit = $attrs.submit? or $attrs.type is 'submit'
      type = if isSubmit then 'submit' else 'button'
      $element.attr('type', type)
      $element.attr('disabled', 'disabled') if $attrs.disabled?
      return
