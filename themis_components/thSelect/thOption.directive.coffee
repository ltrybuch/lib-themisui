angular.module('ThemisComponents')
  .directive "thOption", ->
    restrict: "EA"
    require: "^thSelect"
    template:
      """<option>{{ctrl.text}}</option>"""
    replace: true
    controllerAs: "ctrl"
    bindToController: true
    scope:
      text: "@"
      value: "="
      selected: "="
    controller: ->
      return
    link: (scope, element, attrs, selectCtrl) ->
      # debugger
    #   selectCtrl.setSelected scope
