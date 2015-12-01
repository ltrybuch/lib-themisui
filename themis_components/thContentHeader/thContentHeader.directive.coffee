angular.module('ThemisComponents')
  .directive 'thContentHeader', ->
    restrict: "AE"
    scope:
      title: "@"
    transclude: true
    controllerAs: 'thContentHeader'
    template: require './thContentHeader.template.html' 