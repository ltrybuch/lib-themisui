angular.module('thDemo', ['ThemisComponents'])
  .controller 'DemoCtrl', (PopoverManager) ->
    @headerString = 'thPopover Example 4'
    @clickHandler = ->
      PopoverManager.showPopover(
        targetName: 'target'
        contentCallback: -> PopoverManager.getContent 'content'
      )

    return
