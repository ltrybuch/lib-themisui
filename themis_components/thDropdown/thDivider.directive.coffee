angular.module("ThemisComponents")
  .directive "thDivider", ->
    restrict: "E"
    replace: true
    scope: {}
    template: require('./thDivider.template.html')


