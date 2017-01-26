angular.module("thLazyDemo")
  .controller 'LazyReloadController', (LazyManager) ->
    @reload = ->
      LazyManager.reload "example-name"

    return
