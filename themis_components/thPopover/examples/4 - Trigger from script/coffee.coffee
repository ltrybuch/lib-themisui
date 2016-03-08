angular.module('thDemo', ['ThemisComponents'])
  .controller 'DemoCtrl', (PopoverManager) ->
    @clickHandler = ->
      PopoverManager.showPopover(
        'target'
        PopoverManager.getContent 'content'
      )

    return
