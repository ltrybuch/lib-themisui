angular = require 'angular'

angular.module('ThemisComponentsApp')
  .controller 'ComponentDetailsController', ($scope, $http) ->
    $scope.name = ""
    $scope.readme = """
      # Welcome to the Themis Component Library
      Select a Component on the left to Begin.
    """
    $scope.examples = []

    $scope.$on 'selectedComponent', (event, component) ->
      $http.get "/components/#{component}.json"
      .then (response) ->
        $scope.name = component
        $scope.readme = response.data.readme
        $scope.examples = response.data.examples

    $scope.penData = (name, example) ->
      JSON.stringify
        title: "#{name} - #{example.name}"
        html: example.html
        js: example.coffee
        js_pre_processor: "coffeescript"
        js_external: "http://localhost:3000/assets/themis_components/index.js"
        css_external: "http://localhost:3000/assets/themis_components/index.css"