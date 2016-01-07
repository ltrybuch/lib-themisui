angular.module('ThemisComponents').directive "thFlash", ->
  restrict: "EA"
  replace: true
  bindToController: true
  controllerAs: 'flash'
  template: """
    <div ng-show="flash.messageData.message" class="th-flash {{ flash.messageData.type }}-flash">
      <i class="fa fa-check" ng-show="flash.messageData.type == 'success'"></i>
      <i class="fa fa-warning" ng-show="flash.messageData.type == 'error'"></i>
      {{ flash.messageData.message }}
      <i class="fa fa-times-circle" ng-click="flash.dismiss()"></i>
    </div>
  """
  controller: (FlashManager) ->
    @messageData = FlashManager.flashMessage

    @dismiss = ->
      FlashManager.hideFlash()

    return
