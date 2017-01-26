angular.module("thPopoverDemo")
  .controller "thPopoverDemoCtrl4", (PopoverManager) ->
    @headerString = 'thPopover Example 4'
    @clickHandler = ->
      PopoverManager.showPopover(
        targetName: 'target'
        contentCallback: -> PopoverManager.getContent 'content'
      )

    return
