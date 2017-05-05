angular.module("thPopoverLegacyDemo")
  .controller "thPopoverLegacyDemoCtrl4", (PopoverManager) ->
    @headerString = "thPopover Example 4"
    @clickHandler = ->
      PopoverManager.showPopover(
        targetName: "target"
        contentCallback: -> PopoverManager.getContent "content"
      )

    return
