module.exports = ($compile, $timeout) -> (target, contentAccessor) ->
  {element, attributes} = target

  view = null
  arrow = null
  overlay = null

  scope = getContentPromise = null

  prepareScope = ->
    {getContentPromise, contentScope} = contentAccessor()
    scope = contentScope.$new()

    scope.overflow = attributes.overflow
    scope.loaded = no
    scope.content = ""

    scope.$watch 'content', ->
      positionPopover()

  positionPopover = ->
    return if view is null # We don't want to try positioning views that no longer exist.

    $timeout -> # Wait for the tick after any other dom manipulation is happening.
      # Reset our width so we can measure without being effected
      # by the loading restrictions.
      view.css
        width: "auto"
        bottom: "auto"

      minInset = 12
      arrowOffset = 6

      # Get some sizes we need.
      anchorRect = element[0].getBoundingClientRect()
      viewRect = view[0].getBoundingClientRect()

      # Setup our width. If we are loading set a sensible default.
      maxWidth = window.innerWidth - minInset * 3
      viewWidth = if scope.loaded then Math.min maxWidth, viewRect.width else 200

      # Assuming no window bounds where would we like to be?
      viewGoalLeft = anchorRect.left + anchorRect.width / 2 - viewWidth / 2 - arrowOffset

      # Top boundry
      top = anchorRect.top + anchorRect.height + 10

      # Enforce left boundary.
      minLeft = minInset
      viewLeft = Math.max minLeft, viewGoalLeft

      # Enforce right boundary.
      minRight = window.innerWidth - viewWidth - minInset * 3
      viewLeft = Math.min minRight, viewGoalLeft if viewGoalLeft > 0

      # Get height of the view, as set by user, if set
      goalHeight = viewRect.height
      if goalHeight + top > window.innerHeight
        bottom = minInset

      # Position the popover.
      view.css
        top: "#{ top }px"
        left: "#{ viewLeft }px"
        width: "#{ viewWidth }px"

      if bottom?
        view.css bottom: "#{ bottom }px"

      # Position the arrow
      arrow.css
        top: "#{ top }px"
        left: "#{ anchorRect.left + anchorRect.width / 2 - arrowOffset }px"

      overlay.removeClass 'th-popover-hidden'
      view.removeClass 'th-popover-hidden'
      arrow.removeClass 'th-popover-hidden'

  dismissPopover = ->
    overlay?.remove()
    view?.remove()
    arrow?.remove()

  renderPopover = ->
    unless view?
      view = angular.element require './thPopover.template.html'
    unless overlay?
      overlay = angular.element require './thPopover.overlay.template.html'
    unless arrow?
      arrow = angular.element require './thPopover.arrow.template.html'

    unless scope?
      prepareScope()

    body = angular.element(document.body)
    body.append overlay
    body.append view
    body.append arrow

    overlay.on 'click', ->
      dismissPopover()

    $compile(view)(scope)

    positionPopover()

    view.on 'click', (event) ->
      # When an A tag in a popover and is clicked the popover should normally
      # close. However, we do have components that will live in popovers that
      # will be exceptions to this rule.
      whitelist = [
        '.chzn-container *'
        '.th-switch *'
        '.ui-select-choices-row-inner *' # Select 2 autocompleter
      ]
      whitelistSelector = whitelist.join ', '

      if !event.target.matches(whitelistSelector) and event.target.matches("a, a *")
        scope.$apply -> dismissPopover()

    unless scope.loaded
      getContentPromise().then (content) ->
        scope.loaded = yes
        scope.content = content.data
      , ->
        dismissPopover()

  return {
    renderPopover
  }
