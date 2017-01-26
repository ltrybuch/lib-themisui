angular.module("thContextualMessageDemo")
  .controller "thContextualMessageDemoCtrl1", ($scope, ContextualMessageManager) ->
    messageCount = 0
    $scope.showMessage = ->
      ContextualMessageManager.showMessage "sample", "World. - #{messageCount}"
      messageCount++
