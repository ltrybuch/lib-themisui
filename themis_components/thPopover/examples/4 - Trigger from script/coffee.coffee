angular.module('thDemo', ['ThemisComponents'])
  .controller 'DemoCtrl', (PopoverManager) ->
    @headerString = 'thPopover Example 4'
    @clickHandler = ->
      PopoverManager.showPopover(
        targetName: 'target'
        getContentPromise: -> PopoverManager.getContent 'content'
      )

    return
