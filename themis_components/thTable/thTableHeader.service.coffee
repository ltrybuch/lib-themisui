angular.module 'ThemisComponents'
  .factory 'TableHeader', ->
    class TableHeader
      constructor: (options) ->
        @[key] = options[key] for key in [
          'name'
          'sortField'
          'sortEnabled'
          'align'
        ]