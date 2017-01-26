angular.module("thDisclosureDemo")
  .controller "thDisclosureDemoCtrl5", ->
    @expanded = false
    @disabled = true

    @toggle = ->
      @disabled = !@disabled

    return
