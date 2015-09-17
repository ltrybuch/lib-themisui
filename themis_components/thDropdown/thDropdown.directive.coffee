template = """
  <div class="button-dropdown">
    <div class="dd-overlay" ng-click="dropdown.toggle()" ng-if="dropdown.visible"></div>
    <a href="#"
      ng-class="dropdown.type"
      ng-click="dropdown.toggle()">
      {{dropdown.name}}
      <i class="fa" ng-class="dropdown.toggleCaret()"></i>
    </a>
    <div
      ng-click="dropdown.toggle()"
      ng-if="dropdown.visible"
      class="dropdown-menu"
      >
      <span ng-repeat-start="item in dropdown.processedItems"></span>
        <th-item
          ng-if="item.type == 'link'"
          name="{{item.name}}"
          url="{{item.url}}"
          icon="{{item.icon}}"
        >
        </th-item>
        <th-item
          ng-if="item.type == 'action'"
          name="{{item.name}}"
          action="item.action"
          icon="{{item.icon}}"
        >
        </th-item>
        <th-divider ng-if="item.type == 'divider'"></th-divider>
      <span ng-repeat-end=""></span>
      <ng-transclude></ng-transclude>
    </div>
  </div>
"""

angular.module("ThemisComponents")
  .directive "thDropdown", ->
    restrict: "E"
    template: template
    replace: true
    controllerAs: "dropdown"
    bindToController: true
    transclude: true
    scope:
      name: "@"
      list: "="
      type: "@"
      disabled: "@"
    controller: ($element, $attrs) ->
      @processedItems = []
      @list = @list ? []
      @visible = false

      @toggle = ->
        @visible = !@visible

      @toggleCaret = ->
        if @visible then 'fa-caret-up' else 'fa-caret-down'

      processList = =>
        for item in @list
          if item.url?
            item.type = "link"
            @processedItems.push item
          else if item.action?
            item.type = "action"
            @processedItems.push item
          else
            item.type = "divider"
            @processedItems.push item

      processList()
      return

    link: (scope, elem, attr) ->
      # set button to disabled if attr passed
      elem.find("a").attr('disabled', 'disabled') if attr.disabled?

      elem.on 'click', (event) ->
        menu = elem[0].getElementsByClassName("dropdown-menu")[0]
         # if menu hidden. no need to adjust
        return if menu == undefined

        # sizes needed to check location
        menuWidth = menu?.offsetWidth
        bodyRightPosition = document.body.getBoundingClientRect().right
        buttonRect = elem[0].getBoundingClientRect()

        # adjusted positions
        adjustedTop = buttonRect.top + buttonRect.height + 2
        adjustedRight = bodyRightPosition - buttonRect.right

        # dropdown menu list defaults to right alignment to button
        # if the button is left aligned let's set menu left align
        if (menuWidth > buttonRect.right)
          angular.element(menu).css
            top: adjustedTop
            right: "inherit"
        else
          angular.element(menu).css
            top: adjustedTop
            right: adjustedRight

