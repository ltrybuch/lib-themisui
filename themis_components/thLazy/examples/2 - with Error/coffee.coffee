angular.module('thDemo', ['ThemisComponents'])
  .controller "DemoController", ->
    @errorMessage = "Oops! This was never going to work!"
    @src = "broken/template.html"
