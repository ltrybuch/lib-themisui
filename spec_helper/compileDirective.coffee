# inport the themis components before each test
beforeEach -> angular.mock.module "ThemisComponents"
# Setup everything required to convert an HTML string into a compiled angular element
# Returns an object with element and scope.
# accepts an object to extend scope before compiling the component.
window.compileDirective = (template, scopeAdditions) ->
  compile = scope = null

  # include scope properties before compile
  importScope = ->
    for key, value of scopeAdditions
      scope[key] = value

  # Inject
  inject ($rootScope, $compile, $q, $timeout) ->
    scope = $rootScope.$new()
    compile = $compile

  importScope() if scopeAdditions?

  # Compile template
  wrappedTemplate = "<html ng-app>#{template}</html>"
  compiledElement = compile(wrappedTemplate)(scope)
  scope.$digest()
  return element: jQuery(compiledElement), scope: scope
