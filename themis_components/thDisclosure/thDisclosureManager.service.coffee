angular.module 'ThemisComponents'
  .factory 'DisclosureManager', ->
    handlerMap = {}

    onToggle = (name, handler) ->
      handlerMap[name] = handler
      return # TODO: Why do I need to return?

    toggleExpanded = (name) ->
      (handlerMap[name] ? ->)()

    return {
      onToggle
      toggleExpanded
    }
