angular.module("thDemo", ["ThemisComponents"])
  .controller "DemoCtrl", ->
    return

angular.module "thDemo"
  .run (thDefaults) ->
    thDefaults.set "dateFormat", "DD/MM/YYYY"
