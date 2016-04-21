angular.module('thDemo', ['ThemisComponents'])
  .controller 'LazyReloadController', (LazyManager) ->
    @reload = ->
      LazyManager.reload "example-name"

    return
