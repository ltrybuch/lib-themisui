angular.module("thDatePickerDemo")
  .controller "thDatePickerDemoCtrl2", ->
    return

angular.module "thDatePickerDemo"
  .run (thDefaults) ->
    thDefaults.set "dateFormat", "DD/MM/YYYY"
