angular.module("thSwitchDemo")
  .controller "thSwitchDemoCtrl3", ->
    @state = off
    @changeHandler = ->
      alert "New value: " + @state

    return
