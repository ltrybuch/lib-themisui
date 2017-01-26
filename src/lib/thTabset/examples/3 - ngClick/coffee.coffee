angular.module("thTabsetDemo")
  .controller "thTabsetDemoCtrl3", ->
    @editing = no
    @toggleEditState = -> @editing = !@editing

    return
