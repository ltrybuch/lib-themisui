angular.module("thButtonDemo")
  .controller 'TestButtonController', ->
    @action = ->
      alert('Hello!')
    return
