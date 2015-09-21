linkTemplate = """
  <div class="dropdown-item">
    <a href="{{href}}">
      <i ng-if="icon" class="fa fa-{{icon}}"></i>
      {{name}}
    </a>
  </div>
"""

actionTemplate = """
  <div class="dropdown-item">
    <a href="#" ng-click="action()">
      <i ng-if="icon" class="fa fa-{{icon}}"></i>
      {{name}}
    </a>
  </div>
"""

angular.module("ThemisComponents")
  .directive "thItem", ->
    restrict: "E"
    replace: true
    require: "^thDropdown"
    scope:
      href: "@"
      name: "@"
      icon: "@"
      action: "="
    template: (element, attrs) ->
      switch
        when attrs.href?
          linkTemplate
        else
          actionTemplate





