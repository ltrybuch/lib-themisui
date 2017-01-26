angular.module("thCheckboxDemo")
  .controller "thCheckboxDemoCtrl3", ->
    @checked = false
    @changeHandler = ->
      alert "New value: " + @checked

    return
