angular.module('ThemisComponents')
  .factory 'PopoverManager', ($compile, $timeout, $q, $rootScope) ->
    contents = {}
    targets = {}

    addContent = (contentName, contentHtml) ->
      contents[contentName] = contentHtml

    getContent = (contentName) ->
      $q (resolve, reject) ->
        unless document.body.querySelector("[name=#{contentName}]")
          throw new Error "PopoverManager: content '#{contentName}' not found in document body."

        unless contents.hasOwnProperty contentName
          throw new Error "PopoverManager: content '#{contentName}' does not exist."
        
        resolve({data: contents[contentName]})

    addTarget = (targetName, element, attributes) ->
      targets[targetName] = {scope: $rootScope.$new(), element, attributes}

    showPopover = (targetName, contentPromise) ->
      unless targets.hasOwnProperty(targetName)
        throw new Error "PopoverManager: target '#{targetName}' does not exist."

      target = targets[targetName]

      if not target.renderPopover?
        {renderPopover} = addPopoverToTarget(target, contentPromise)
        target.renderPopover = renderPopover

      target.renderPopover()

    attachPopover = (element, attributes, contentPromise) ->
      {renderPopover} = addPopoverToTarget(
        {scope: $rootScope.$new(), element, attributes}
        contentPromise
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
