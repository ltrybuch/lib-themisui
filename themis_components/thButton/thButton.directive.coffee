template = """
  <button
    class="th-button"
    >
    {{buttonCtrl.text}}
  </button>
"""

angular.module('ThemisComponents')
  .directive "thButton", ($window) ->
    restrict: "EA"
    template: template
    replace: true
    scope:
      text: '@'
    link: (scope, element, attrs) ->
      element.attr('disabled','disabled') if attrs.disabled?
      element.attr('type', 'button') unless attrs.type?
      element.removeAttr('text');
      element.on 'click', ->
        if attrs.href?
          scope.$apply -> 
            $window.location.replace(attrs.href)
    bindToController: true
    controllerAs: 'buttonCtrl'
    controller: ->
      return
