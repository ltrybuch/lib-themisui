angular = require 'angular'

angular.module('ThemisComponentsApp')
  .controller 'ComponentDetailsController', ($scope, $http, $sce, $browser, $timeout) ->
    # Set blank state
    $scope.name = ""
    $scope.readme =
        markdown: "**Select a Component**"
    $scope.examples = []

    $scope.$on 'selectedComponent', (event, component) ->
      $http.get "/components/#{component}.json"
      .then (response) ->
        $scope.name = component
        $scope.readme =
          markdown: response.data.readme
          html: $sce.trustAsHtml response.data.readmeHTML
        $scope.examples = response.data.examples

    $scope.penData = (name, example) ->
      JSON.stringify
        title: "#{name} - #{example.name}"
        html: example.html
        js: example.coffee
        js_pre_processor: "coffeescript"
        js_external: "http://localhost:3000/assets/themis_components/index.js"
        css_external: "http://localhost:3000/assets/themis_components/index.css"