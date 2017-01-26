angular.module("thLoaderDemo")
  .controller "thLoaderDemoCtrl2", ->
    @timeout = 0

    @updateTimeout = ->
      @timeout = 4000

    return
