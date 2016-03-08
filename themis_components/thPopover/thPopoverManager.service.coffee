angular.module('ThemisComponents')
  .factory 'PopoverManager', ($compile, $timeout, $q) ->
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

    addTarget = (targetName, $scope, element, attributes) ->
      targets[targetName] = {$scope, element, attributes}

    showPopover = (targetName, contentPromise) ->
      unless targets.hasOwnProperty(targetName)
        throw new Error "PopoverManager: target '#{targetName}' does not exist."

      target = targets[targetName]

      if not target.renderPopover?
        {renderPopover} = addPopoverToTarget(target, contentPromise)
        target.renderPopover = renderPopover

      target.renderPopover()

    attachPopover = ($scope, element, attributes, contentPromise) ->
      {renderPopover} = addPopoverToTarget(
        {$scope, element, attributes}
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
