angular.module("ThemisComponents")
  .directive "thModalAnchor", ->
    restrict: "EA"
    replace: true
    controllerAs: "anchor"
    bindToController: true
    template: require "./thModalAnchor.template.html"
    controller: (ModalManager) ->
      @modals = ModalManager._modals

      if @modals.length > 0
        @showFullPageModal = @modals[0].size is "fullpage"
        @modalLimit = if @showFullPageModal then 2 else 1

      return
