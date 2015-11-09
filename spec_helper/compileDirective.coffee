# Setup everything required to convert an HTML string into a compiled angular element
# Returns an object with element and scope.
# accepts an object to extend scope before compiling the component.
window.compileDirective = (template, scopeAdditions) ->
  compile = scope = q = null
  # Import components
  angular.mock.module 'ThemisComponents'

  # include scope properties before compile
  importScope = ->
    for key, value of scopeAdditions
      scope[key] = value

  # Inject
  inject ($rootScope, $compile, $q, $timeout) ->
    scope = $rootScope.$new()
    compile = $compile
    q = $q

  importScope() if scopeAdditions?

  if scopeAdditions?.promise
    scope.deferred = q.defer()
    scope.promise = scope.deferred.promise

  # Compile template
  wrappedTemplate = "<html ng-app>#{template}</html>"
  compiledElement = compile(wrappedTemplate)(scope)
  scope.$digest()
  return element: jQuery(compiledElement), scope: scope
