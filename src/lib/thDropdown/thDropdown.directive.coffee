keycode = require "keycode"

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
      ariaLabel: "@"
      ariaDescribedby: "@"
      ngDisabled: "=?"
    controller: ($element, $attrs, $timeout) ->
      @processedItems = []
      @list = @list ? []
      @visible = false
      @currentItemIndex = 0
      element = $element[0]
      @ariaLabel ?= @name
      @disabledWithAttribute = $attrs.disabled?

      @keyboardToggle = (event) =>
        unless $attrs.disabled?
          switch event.keyCode
            when keycode('Enter')
              if @visible == true
                @selectOption()
              else
                @toggle()
              event.preventDefault()

            when keycode('Space')
              if @visible == true
                @selectOption()
              else
                @toggle()
              event.preventDefault()

            when keycode('Escape')
              @visible = false
              # Set focus to the button element
              angular.element(element).find("button")[0].focus()
              event.preventDefault()

            when keycode('Down')
              focusOptionInDirection('down')
              event.preventDefault()

            when keycode('Up')
              focusOptionInDirection('up')
              event.preventDefault()

      @selectOption = ->
        $timeout =>
          angular.element(document.activeElement.parentElement).triggerHandler 'click'
          @visible = !@visible
          @currentItemIndex = 0

      @toggle = ->
        @visible = !@visible
        @currentItemIndex = 0
        $timeout =>
          if @visible == false
            element.focus()
          else
            angular.element(document.body).find(".dropdown-menu a")[0].focus()

      @toggleCaret = ->
        if @visible then 'fa-caret-up' else 'fa-caret-down'

      focusOptionInDirection = (direction) =>
        index = if direction == 'down' then @currentItemIndex + 1 else @currentItemIndex - 1
        option = document.getElementsByClassName("dropdown-item")[index]
        if option
          switch direction
            when 'down'
              @currentItemIndex++
            when 'up'
              @currentItemIndex--
          option.focus()

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
