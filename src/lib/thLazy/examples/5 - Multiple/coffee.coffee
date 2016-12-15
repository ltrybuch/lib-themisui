angular.module('thDemo', ['ThemisComponents'])
  .controller 'LazyController', ->

    @src1 = "exampleTemplates/thLazyExampleTemplate1.html?foo=bar"
    @src2 = "exampleTemplates/thLazyExampleTemplate2.html?foo=bar"

    return
