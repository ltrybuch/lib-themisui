template = """
  <div class="button-dropdown">
    <div class="th-dropdown-overlay" ng-click="dropdown.toggle()" ng-if="dropdown.visible"></div>
    <a href="#" ng-class="dropdown.color" ng-click="dropdown.toggle()">
    {{dropdown.name}}
      <i class="fa" ng-class="dropdown.visible ? 'fa-caret-up' : 'fa-caret-down'"></i>
    </a>
    <ul ng-if="dropdown.visible" class="dd-list-container">
      <li ng-repeat="item in dropdown.links" ng-click="dropdown.toggle()" ng-class="{'iconless-padding':dropdown.addPadding(item.icon) }">
        <a ng-if="item.url" href="{{item.url}}">
          <i ng-if="item.icon" class="fa fa-{{item.icon}}"></i>
          {{item.name}}
        </a>
        <a ng-if="item.action" href="#" ng-click="item.action()">
          <i ng-if="item.icon" class="fa fa-{{item.icon}}"></i>
          {{item.name}}
        </a>
      </li>
    </ul>
  </div>
"""
angular.module("ThemisComponents")
  .directive "thDropdown", ->
    restrict: "E"
    template: template
    replace: true
    controllerAs: "dropdown"
    bindToController: true
    scope:
      name: "@"
      list: "="
      color: "@"
    controller: ->
      @links = []
      @visible = false
      @withIcons = no

      @toggle = ->
        @visible = !@visible

      @addPadding = (icon) ->
        !icon && @withIcons

      processList = =>
        for item in @list
          if item.url? && item.action?
            console.log "Broken link"
          else
            if item.url? && typeof item.url == "string"
              link = {}
              link.name = item.name
              link.url = item.url
              if item.icon
                link.icon = item.icon
                @withIcons = yes
              @links.push link
            else if item.action? && typeof item.action == "function"
              link = {}
              link.name = item.name
              link.action = item.action
              if item.icon
                link.icon = item.icon
                @withIcons = yes
              @links.push link

      processList()

      return

    link: (scope, elem, attr) ->
      elem.on 'click', (event) ->
        # sizes needed to check location
        listSize = elem.find("ul")[0]?.offsetWidth
        bodyLeftPosition = document.body.getBoundingClientRect().left
        elementLeftPosition = elem[0].getBoundingClientRect().left

        # dropdown ul defaults to right alignment
        # if our dropdown is left aligned let move ul left aligned
        elementDistanceFromLeftEdge = elementLeftPosition - bodyLeftPosition
        if (elementDistanceFromLeftEdge < listSize)
          elem.find("ul").css
            left: "0"

