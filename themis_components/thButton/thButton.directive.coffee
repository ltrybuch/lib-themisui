template = """
  <button
    class="th-button"
    type="{{ buttonCtrl.type }}"
    >
    {{ buttonCtrl.text }}
  </button>
"""

angular.module('ThemisComponents')
  .directive "thButton", ($window) ->
    restrict: "EA"
    template: template
    replace: true
    scope:
      type:     '@type'
      text:     '@text'
    link: (scope, element, attrs) ->
      element.attr('disabled','disabled') if attrs.disabled?
      element.on 'click', ->
        if attrs.href?
          scope.$apply -> 
            $window.location = attrs.href
    bindToController: true
    controllerAs: 'buttonCtrl'
    controller: ->
      @type = @type ? 'button'
      return
