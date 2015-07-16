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
    getTemplate = (type) ->
      template = null
      switch type
        when 'href' then template = anchorTemplate
        else template = buttonTemplate
      return template

    linker = (scope, element, attrs) ->
      # Dynamically set our template based on the existance of an href
      templateType = if attrs.href? then 'href' else 'button'
      html = angular.element(getTemplate(templateType))
      element.replaceWith(html)
      # Set attributes on the dynamic element
      buttonType = if attrs.type? then attrs.type else 'button'
      html.attr('type', buttonType)
      html.attr('disabled','disabled') if attrs.disabled?
      html.attr('ng-click', 'button.action()') if attrs.ngClick
      html.removeAttr('text')
      # Compile it all
      $compile(html)(scope)

    restrict: "EA"
    scope:
      text:   '@text'
      thType: '@thType'
      href:   '@href'
      action: '&ngClick'
    link: linker
    bindToController: true
    controllerAs: 'button'
    controller: ->
      return
