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
      $element.attr('type', 'submit') if $attrs.submit?
      $element.attr('disabled', 'disabled') if $attrs.disabled?
      return
