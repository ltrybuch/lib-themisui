angular.module 'ThemisComponents'
  .factory 'TableDelegate', ->
    class TableDelegate
      constructor: (options) ->
        for key, value of options
          @[key] = value

      post: (rows) ->
        throw new Error "Method not implemented"
