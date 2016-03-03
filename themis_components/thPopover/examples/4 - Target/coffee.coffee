angular.module('thDemo', ['ThemisComponents'])
  .controller 'DemoCtrl', (PopoverManager) ->
    @clickHandler = ->
      PopoverManager.showPopover('target', 'content')

    return
