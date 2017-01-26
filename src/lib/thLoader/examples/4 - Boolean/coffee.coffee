angular.module("thLoaderDemo")
  .controller "thLoaderDemoCtrl4", ->
    @state = on
    @toggle = -> @state = !@state

    return
