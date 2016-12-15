angular.module('ThemisComponents')
  .factory 'PopoverManager', ($compile, $timeout, $q) ->
    contents = {}
    targets = {}

    addContent = (contentName, contentHtml, contentScope) ->
      contents[contentName] = {
        getContentPromise: -> $q (resolve, reject) ->
          resolve {data: contentHtml}
        contentScope
      }

    getContent = (contentName) ->
      unless document.body.querySelector("[name=#{contentName}]")
        throw new Error "PopoverManager: content '#{contentName}' not found in document body."

      unless contents.hasOwnProperty contentName
        throw new Error "PopoverManager: content '#{contentName}' does not exist."

      contents[contentName]

    addTarget = (targetName, element) ->
      targets[targetName] = {element}

    hidePopover = (targetName) ->
      unless targets.hasOwnProperty targetName
        throw new Error "PopoverManager: target '#{targetName}' does not exist."

      target = targets[targetName]
      target.dismissPopover() if target.dismissPopover?

    showPopover = (options = {}) ->
      {
        targetName        # String: Required
        contentCallback   # Function: Required
      } = options

      unless targets.hasOwnProperty targetName
        throw new Error "PopoverManager: target '#{targetName}' does not exist."

      unless contentCallback instanceof Function
        throw new Error "PopoverManager: options must have Function " + \
          "'contentCallback'."

      target = targets[targetName]

      if not target.renderPopover?
        {
          dismissPopover
          renderPopover
        } = addPopoverToTarget(target, contentCallback)
        target.renderPopover = renderPopover
        target.dismissPopover = dismissPopover

      $timeout ->
        target.renderPopover()

    attachPopover = (element, contentCallback) ->
      {renderPopover} = addPopoverToTarget(
        {element}
        contentCallback
      )

      element.on 'click', ->
        renderPopover()

    addPopoverToTarget = require('./thAddPopover.helper')($compile, $timeout)

    return {
      attachPopover
      showPopover
      hidePopover
      addContent
      getContent
      addTarget
    }
