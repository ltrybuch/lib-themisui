template = """
  <div class="button-dropdown">
    <div class="th-dropdown-overlay" ng-click="dropdown.toggle()" ng-if="dropdown.visible"></div>
    <a href="#" ng-class="dropdown.color" ng-click="dropdown.toggle()">
      {{dropdown.name}}
      <i class="fa" ng-class="dropdown.toggleCaret()"></i>
    </a>
      <ul ng-if="dropdown.visible" class="dd-list-container">
        <li
          ng-repeat="item in dropdown.links"
          ng-click="dropdown.toggle()"
          class="{{dropdown.addDividerClass(item.type)}} {{dropdown.noIconPadding(item.icon)}}"
        >
          <a ng-if="item.type == 'link'" href="{{item.url}}">
            <i ng-if="item.icon" class="fa fa-{{item.icon}}"></i>
            {{item.name}}
          </a>
          <a ng-if="item.type == 'action'" href="#" ng-click="item.action()">
            <i ng-if="item.icon" class="fa fa-{{item.icon}}"></i>
            {{item.name}}
          </a>
          <div ng-if="item.type == 'divider'" class="divider"></div>
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

      @noIconPadding = (icon) ->
        # if some li include icons line up text
        if !icon && @withIcons
          "iconless-padding"

      @addDividerClass = (type) ->
        "divider-container" if type == "divider"

      @toggleCaret = ->
        if @visible then 'fa-caret-up' else 'fa-caret-down'

      processList = =>
        for item in @list
          if item.url? && item.action?
            console.log "Broken link"
          else
            if item.url? && typeof item.url == "string"
              handleLink(item)
            else if item.action? && typeof item.action == "function"
              handleAction(item)
            else if item.type == "divider"
              handleDivider(item)

      handleDivider = (item) =>
        link = {}
        link.type = item.type
        @links.push link

      handleLink = (item) =>
        link = {}
        link.name = item.name
        link.url = item.url
        link.type = "link"
        if item.icon
          link.icon = item.icon
          @withIcons = yes
        @links.push link

      handleAction = (item) =>
        link = {}
        link.name = item.name
        link.action = item.action
        link.type = "action"
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

