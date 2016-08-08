angular.module('thDemo', ['ThemisComponents'])
  .controller "DemoController", ->
    @count = 0
    @plusOne = -> ++@count
    @reset = -> @count = 0
    return
