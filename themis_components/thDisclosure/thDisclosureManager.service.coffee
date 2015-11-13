angular.module 'ThemisComponents'
  .factory 'DisclosureManager', ->
    handlerMap = {}

    onToggle = (name, handler) ->
      handlerMap[name] = handler
      return # TODO: Why do I need to return?

    toggle = (name) ->
      (handlerMap[name] ? ->)()

    return {
      onToggle
      toggle
    }
