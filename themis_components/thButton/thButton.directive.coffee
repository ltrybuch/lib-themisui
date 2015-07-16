anchorTemplate = """
  <a 
    class="th-button {{button.thType}}"
    href="{{button.href}}"
    >
    {{button.text}}
  </a>
"""

buttonTemplate = """
  <button class="th-button {{button.thType}}">
    {{button.text}}
  </button>
"""

angular.module('ThemisComponents')
  .directive "thButton", ($compile) ->
    restrict: "EA"
    scope:
      text:   '@text'
      thType: '@thType'
      href:   '@href'
    replace: true
    template: (element, attributes) ->
      switch
        when attributes.href?
          anchorTemplate
        else
          buttonTemplate
    bindToController: true
    controllerAs: 'button'
    controller: ($element, $attrs) ->
      buttonType = $attrs.type ? 'button'
      $element.attr('type', buttonType)
      $element.attr('disabled', 'disabled') if $attrs.disabled?
      return
