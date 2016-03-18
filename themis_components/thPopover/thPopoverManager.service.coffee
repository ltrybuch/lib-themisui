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

    showPopover = (options = {}) ->
      {
        targetName        # String: Required
        contentCallback   # Function: Required
      } = options

      unless targets.hasOwnProperty(targetName)
        throw new Error "PopoverManager: target '#{targetName}' does not exist."

      # unless getContentPromise instanceof Function
      #   throw new Error "PopoverManager: getContentPromise must be of type 'Function'"

      target = targets[targetName]

      if not target.renderPopover?
        {renderPopover} = addPopoverToTarget(target, contentCallback)
        target.renderPopover = renderPopover

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
      addContent
      getContent
      addTarget
    }
