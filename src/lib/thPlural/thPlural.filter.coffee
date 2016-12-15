plural = require('pluralize')

angular.module('ThemisComponents').filter "pluralize", ->
  (string = "", count = 0) -> plural string, count
