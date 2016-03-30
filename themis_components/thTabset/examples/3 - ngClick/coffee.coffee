angular.module('thDemo', ['ThemisComponents'])
  .controller "DemoController", ->
    @editing = no
    @toggleEditState = -> @editing = !@editing

    return
