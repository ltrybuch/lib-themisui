angular.module 'ThemisComponents'
  .factory 'TableDelegate', ->
    class TableDelegate
      constructor: (options) ->
        @[key] = value for key, value of options

      post: (rows) ->
        throw new Error "Method not implemented"
