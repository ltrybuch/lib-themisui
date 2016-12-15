uuid = require "uuid"
debounce = require "debounce"

getOverflowParent = (element) ->
  parent = element.parentElement

  return element if element is window.document.body
  return element unless parent

  overflowX = window.getComputedStyle(parent).overflowX
  if overflowX is "visible"
    return getOverflowParent(parent)
  else
    return parent

menuMaxWidth = (element) ->
  elementLeft = element.getBoundingClientRect().left

  overflowParent = getOverflowParent element
  overflowParentRect = overflowParent.getBoundingClientRect()
  overflowParentLeft = overflowParentRect.left
  overflowParentWidth = overflowParentRect.width
  padRight = 20

  elementDistanceFromOverflowParentLeft = elementLeft - overflowParentLeft

  return overflowParentWidth - elementDistanceFromOverflowParentLeft - padRight

angular.module "ThemisComponents"
  .directive "thAutocomplete", ($compile, $interpolate, $timeout, $window) ->
    restrict: "E"
    require: ["?^form", "thAutocomplete"]
    scope:
      ngModel: "=?"
      ngChange: "&?"
      ngDisabled: "=?"
      ngRequired: "=?"
      delegate: "="
      name: "@?"
      placeholder: "@?"
      icon: "@?"
      condensed: "=?"
      multiple: "@?"
      showSearchHint: "<?"
    bindToController: true
    controllerAs: "thAutocomplete"

    controller: ($element) ->
      @data = []
      @lastValue = null
      searchHintText = "Search to find more results"
      @styleIdentifier = uuid.v1()

      @updateData = (data, showSearchHint) =>
        throw new Error "UpdateData: data must be of type Array" unless data instanceof Array
        @data = data
        @showSearchHint = showSearchHint
        @_toggleSearchHintElement()

      @_toggleSearchHintElement = ->
        $timeout =>
          choices = angular.element($element[0].querySelectorAll(".ui-select-choices"))
          hintExists = choices.querySelectorAll(".hint").length > 0
          if @showSearchHint is on
            choices.append "<div class='hint'>#{searchHintText}</div>" unless hintExists
          else
            angular.element($element[0].querySelectorAll(".hint")).remove()

      @$postLink = ->
        $timeout =>
          @_toggleSearchHintElement()

      return
    link: (scope, element, attrs, controllerArray) ->
      form = controllerArray[0]
      controller = controllerArray[1]
      fieldName = controller.name or null

      multiple = controller.multiple?
      delegate = controller.delegate
      unless delegate?.fetchData instanceof Function
        throw new Error "thAutocomplete delegate needs to be passed the following function: " + \
                        "fetchData: ({searchTerm}, updateData) ->"

      # If autocomplete value is invalid append class.
      controller.isInvalid = ->
        return no unless form and fieldName
        form[fieldName].$invalid and (form[fieldName].$touched or form.$submitted)

      # This is to accomodate a bug in ui-select (multiple only) where the form
      # model is not invalidated after it's cleared.
      if controller.ngRequired and multiple and form and fieldName
        scope.$watch ->
          form[fieldName].$modelValue
        , (newValue) ->
          if not newValue?.length
            form[fieldName].$setValidity "required", false

      controller.trackField = delegate.trackField ? "id"

      template = (require "./thAutocomplete.template")({
        interpolateStart: $interpolate.startSymbol()
        interpolateEnd: $interpolate.endSymbol()
        valueField: controller.trackField
        multiple
      })
      templateElement = angular.element template

      # Add repeat attribute to ui-select-choices element.
      repeatExpression = "item in thAutocomplete.data track by item.#{controller.trackField}"

      selectChoicesElement = templateElement.find "ui-select-choices"
      selectChoicesElement.attr(
        "repeat"
        repeatExpression
      )

      # Add display field to inner html of ui-select-choices and ui-select-match elements.
      displayField = delegate.displayField ? "name"

      selectChoicesElement.html "<span ng-bind='item.#{displayField}'></span>"

      selectMatchHtml =
        if multiple
          "<span ng-bind='$item.#{displayField}'></span>"
        else
          "<span ng-bind='$select.selected.#{displayField}'></span>"

      selectMatchElement = templateElement.find "ui-select-match"
      selectMatchElement.html selectMatchHtml

      # ui-select needs access to the parent's scope for evaluating repeat.
      childScope = scope.$parent.$new false, scope

      # We are attaching the table's controller to the scope, so that the
      # template has access to it.
      childScope.thAutocomplete = scope.thAutocomplete

      compiledTemplate = $compile(templateElement) childScope
      element.append compiledTemplate

      # This sets the text of the input field to the full text of the
      # selected value.
      copyValueToSearchField = (search) ->
        $timeout ->
          search = angular.element(element[0].querySelectorAll(".ui-select-search"))
          modelName = controller.ngModel?[displayField] or null
          search.val modelName
          controller.lastSearch = modelName

      # This clears the autocomplete (in single-selection only) when the
      # user clears the input text
      checkForEmptySearchField = ->
        if not multiple
          search = angular.element(element[0].querySelectorAll(".ui-select-search"))
          lastSearchIsEmpty = not (controller.lastSearch?.length > 0)
          thisSearchIsEmpty = not (search.val()?.length > 0)

          # We only want to set model to null when the user has actually cleared
          # the field. If it was already empty then don't clear it again
          if not lastSearchIsEmpty and thisSearchIsEmpty
            controller.ngModel = null

      controller.onSelect = ->
        modelValue = controller.ngModel?[controller.trackField]
        if controller.lastValue isnt modelValue
          controller.lastValue = modelValue
          controller.ngChange?()

        copyValueToSearchField() if not multiple

      scope.$watch "thAutocomplete.ngModel", (newValue) ->
        if newValue is null
          controller.lastValue = controller.data = null
          copyValueToSearchField() if not multiple

      # Handle Dynamic Width
      updateMenuMaxWidth = debounce ->
        scope.thAutocomplete.menuMaxWidth = menuMaxWidth(element[0])
        scope.$apply()
      , 100

      updateMenuMaxWidth()
      $window.addEventListener "resize", updateMenuMaxWidth
      scope.$on "$destroy", -> $window.removeEventListener "resize", updateMenuMaxWidth

      $timeout ->
        # Toggle container shadow when input has focus.
        focusser = angular.element(element[0].querySelectorAll(".ui-select-focusser"))
        search = angular.element(element[0].querySelectorAll(".ui-select-search"))
        choicesDropdown = angular.element(element[0].querySelectorAll(".ui-select-choices"))
        container = angular.element(element[0].querySelectorAll(".ui-select-container"))

        triggerInputTouched = ->
          form?[fieldName].$setTouched()

        search.on "keydown", (event) ->
          enterKeyCode = 13
          if not multiple and event.which is enterKeyCode
            checkForEmptySearchField()
            # Set the focus back on the search element on enter.
            $timeout ->
              focusser[0].focus()
            , 50

        choicesMouseDown = no

        choicesDropdown.on "mousedown", ->
          choicesMouseDown = yes

        choicesDropdown.on "mouseup", ->
          choicesMouseDown = no
          triggerInputTouched()

          # Pass focus back to the search input; this is not the default
          # behaviour of ui-select.
          search[0].focus() if multiple

        search.on "focus", ->
          updateMenuMaxWidth()
          container.addClass("has-focus") if multiple

        search.on "blur", ->
          $timeout ->
            # If focussed element is the dropdown list then…
            activeElement = document.activeElement # Looking for dropdown list.
                              ?.parentElement
                              ?.parentElement
                              ?.parentElement

            focusOnDropdown = activeElement is choicesDropdown[0]
            # …set the focus back on the search element.
            if not multiple and focusOnDropdown
              $timeout (-> focusser[0].focus()), 150

          # This is to account for the search input blurring when the user
          # clicks on the choices dropdown. If the user is mid-click, we don't
          # set the field to `touched` until mouse-up (and the item is
          # selected). If it's set to touched before an item is selected, the
          # element would be in an `invalid` state for the duration of the click.
          triggerInputTouched() unless choicesMouseDown

          if multiple
            container.removeClass("has-focus")
          else
            checkForEmptySearchField()

            copyValueToSearchField()