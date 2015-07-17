anchorTemplate = """
  <a class="th-button" href="{{button.href}}" ng-transclude></a>
"""

buttonTemplate = """
  <button class="th-button {{button.type}}" ng-transclude></button>
"""

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
          anchorTemplate
        else
          buttonTemplate
    bindToController: true
    controllerAs: 'button'
    controller: ($element, $attrs) ->
      $element.attr('type', 'submit') if $attrs.submit?
      $element.attr('disabled', 'disabled') if $attrs.disabled?
      return
