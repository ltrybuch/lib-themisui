angular.module 'ThemisComponents'
.factory 'CustomFilterConverter', ->
  class CustomFilterConverter
    mapToCustomFilterArray: (data) ->
      throw new Error "'CustomFilterConverter' must implement Function " + \
                      "'mapToCustomFilterArray(data)'"
