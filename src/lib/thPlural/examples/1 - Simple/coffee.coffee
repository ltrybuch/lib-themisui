angular.module("thPluralDemo")
  .controller "thPluralDemoCtrl1", ->
    @count = 0
    @plusOne = -> ++@count
    @reset = -> @count = 0
    return
