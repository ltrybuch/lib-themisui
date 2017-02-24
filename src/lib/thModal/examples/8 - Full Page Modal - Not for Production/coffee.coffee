angular.module("thModalDemo")
  .controller "thModalDemoCtrl8", ($scope, ModalManager) ->
    @path = "/components/thModal/examples/" +
      "8 - Full Page Modal - Not for Production/thModalExampleTemplate.html"

    @user =
      user:
        firstName: "Clark"
        lastName: "Kent"
        email: "clark.kent@dailyplanet.dc"

    @displayFPModal = =>
      @fromModal = {}
      ModalManager.show path: @path, name: "fullpage", context: @user, size: "fullpage"
        .then (data) =>
          @fromModal = data
    return

  .controller "thModalEmailCtrl", ($scope, ModalManager) ->
    @path = "/components/thModal/examples/" +
      "8 - Full Page Modal - Not for Production/thModalExampleTemplate2.html"
    @user = angular.copy $scope.modal.context.user
    @modalSize = $scope.modal.size

    @displayEmailModal = =>
      ModalManager.show path: @path, name: "email", context: @user.email
        .then (data) =>
          @user.email = data
    @confirm = (data) ->
      $scope.modal.confirm data
    @dismiss = ->
      $scope.modal.dismiss "fullpage"

    return
