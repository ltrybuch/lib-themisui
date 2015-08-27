# Setup everything required to convert an HTML string into a compiled angular element
# Returns an object with element and scope.
window.compileDirective = (template, options) ->
  compile = scope = q = null
  # Import components
  angular.mock.module 'ThemisComponents'

  # Inject
  inject ($rootScope, $compile) ->
    scope = $rootScope.$new()
    compile = $compile

  if options and options.promise
    inject ($q) -> q = $q
    scope.deferred = q.defer()
    scope.promise = scope.deferred.promise

  # Compile template
  wrappedTemplate = "<html ng-app>#{template}</html>"
  compiledElement = compile(wrappedTemplate)(scope)
  scope.$digest()
  {element: jQuery(compiledElement), scope: scope}
