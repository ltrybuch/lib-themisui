angular.module("thRadioGroupDemo")
  .controller "thRadioGroupDemoCtrl4", ->
    @value = 'one'
    @changeHandler = ->
      alert "New value: " + @value

    return
