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

    getContentAccessor = (contentName) -> ->
      unless document.body.querySelector("[name=#{contentName}]")
        throw new Error "PopoverManager: content '#{contentName}' not found in document body."

      unless contents.hasOwnProperty contentName
        throw new Error "PopoverManager: content '#{contentName}' does not exist."

      contents[contentName]

    addTarget = (targetName, element, attributes) ->
      targets[targetName] = {element, attributes}

    showPopover = (options = {}) ->
      {
        targetName        # String: Required
        contentAccessor   # Function: Required
      } = options

      unless targets.hasOwnProperty(targetName)
        throw new Error "PopoverManager: target '#{targetName}' does not exist."

      # unless getContentPromise instanceof Function
      #   throw new Error "PopoverManager: getContentPromise must be of type 'Function'"

      target = targets[targetName]

      if not target.renderPopover?
        {renderPopover} = addPopoverToTarget(target, contentAccessor)
        target.renderPopover = renderPopover

      target.renderPopover()

    attachPopover = (element, attributes, contentAccessor) ->
      {renderPopover} = addPopoverToTarget(
        {element, attributes}
        contentAccessor
      )

      element.on 'click', ->
        renderPopover()

    addPopoverToTarget = require('./thAddPopover.helper')($compile, $timeout)

    return {
      attachPopover
      showPopover
      addContent
      getContentAccessor
      addTarget
    }
