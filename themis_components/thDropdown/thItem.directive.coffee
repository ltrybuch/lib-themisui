linkTemplate = """
  <div class="dropdown-item">
    <a href="{{url}}">
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
      url: "@"
      name: "@"
      icon: "@"
      action: "="
    template: (element, attrs) ->
      switch
        when attrs.url?
          linkTemplate
        else
          actionTemplate





