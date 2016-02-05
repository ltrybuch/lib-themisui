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

# .click() on a DOM node is not standard in PhantomJS v1.9.19
# You need to create an event and dispatch it.
# http://stackoverflow.com/a/17789929
if /PhantomJS/.test(window.navigator.userAgent)
  if !HTMLElement::click
    HTMLElement::click = ->
      ev = document.createEvent('MouseEvent')
      ev.initMouseEvent(
        'click', true, true, window, null, 0, 0, 0, 0,
        false, false, false, false, 0, null
      )
      @dispatchEvent ev
