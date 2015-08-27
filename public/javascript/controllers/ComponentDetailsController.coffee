angular = require 'angular'

angular.module('ThemisComponentsApp')
  .controller 'ComponentDetailsController', ($scope, $http, $sce) ->
    # Set blank state
    $scope.name = ""
    $scope.readme =
        markdown: """
          <br><br>
          **Greetings,**

          Please explore the available components and let us know if you have any questions.

          *Cheerio!*

          <a href="https://github.com/clio/lib-themisui" target="_blank">
            <img style="position: absolute; top: 0; right: 0; border: 0;" src="https://camo.githubusercontent.com/a6677b08c955af8400f44c6298f40e7d19cc5b2d/68747470733a2f2f73332e616d617a6f6e6177732e636f6d2f6769746875622f726962626f6e732f666f726b6d655f72696768745f677261795f3664366436642e706e67" alt="Fork me on GitHub" data-canonical-src="https://s3.amazonaws.com/github/ribbons/forkme_right_gray_6d6d6d.png">
          </a>
        """
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
