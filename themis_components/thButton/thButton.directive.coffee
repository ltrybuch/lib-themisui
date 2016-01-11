angular.module('ThemisComponents')
  .directive "thButton", ($compile) ->
    restrict: "EA"
    scope:
      type: '@'
      href: '@'
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
    controller: ($element, $attrs) ->
      type = if $attrs.submit? || $attrs.type == 'submit' then 'submit' else 'button'
      $element.attr('type', type)
      $element.attr('disabled', 'disabled') if $attrs.disabled?
      return
