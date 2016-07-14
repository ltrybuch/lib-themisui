angular.module("ThemisComponents")
  .directive "thDropdown", ->
    restrict: "E"
    template: require './thDropdown.template.html'
    replace: true
    controllerAs: "dropdown"
    bindToController: true
    transclude: true
    scope:
      name: "@"
      list: "=?"
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
          if item.href?
            item.type = "link"
            @processedItems.push item
          else if item.ngClick?
            item.type = "action"
            @processedItems.push item
          else
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
        # append to the body to avoid overflow issues with parent element
        body = angular.element(document.body)
        body.append(menu)

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
