# https://www.foo.com:3030/some/deep/page?foo=bar => /some/deep/page
pathFromUrl = (url) ->
  parser = document.createElement('a');
  parser.href = url;
  parser.pathname

# Retrieve component name from URL, taking the base path into consideration
getComponentName = (url) ->
  path = pathFromUrl(url)
  basePath = pathFromUrl(document.querySelector("base").href || "")
  path.replace(basePath, "").split("/")[0]

# Enable HTML5 routing and broadcast component name on page load
angular.module('ThemisComponentsApp')
  .config ($locationProvider) ->
    $locationProvider.html5Mode(true)
  .run ($rootScope, $timeout) ->
    $rootScope.$on '$locationChangeSuccess', (event, url) ->
      componentName = getComponentName(url)
      return if componentName == ""
      $timeout -> $rootScope.$broadcast 'selectedComponent', componentName
