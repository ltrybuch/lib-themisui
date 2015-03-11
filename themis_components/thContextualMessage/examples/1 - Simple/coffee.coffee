angular.module('thDemo', ['ThemisComponents'])
  .controller 'DemoController', ($scope, ContextualMessageManager) ->
    messageCount = 0
    $scope.showMessage = ->
      ContextualMessageManager.showMessage "sample", "World. - #{messageCount}"
      messageCount++