# Import the themis components before each test.
beforeEach -> angular.mock.module "ThemisComponents"


# Returns an angular element after it's compiled with scope.
window.compileDirective = (template, scopeAdditions) ->
  compile = scope = null

  # Include scope properties before compile.
  importScope = ->
    for key, value of scopeAdditions
      scope[key] = value

  # Inject.
  inject ($rootScope, $compile) ->
    scope = $rootScope.$new()
    compile = $compile

  importScope() if scopeAdditions?

  # Compile template.
  wrappedTemplate = "<html ng-app>#{template}</html>"
  compiledElement = compile(wrappedTemplate)(scope)
  scope.$digest()
  return element: jQuery(compiledElement), scope: scope


# Creates a raw DOM element from a string template.
# Only works for templates with a single root node.
window.createDOMElement = (template) ->
  div = document.createElement 'div'
  div.innerHTML = template
  return div.firstChild
