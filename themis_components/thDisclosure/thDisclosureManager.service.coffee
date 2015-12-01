angular.module 'ThemisComponents'
  .factory 'DisclosureManager', ->
    handlerMap = {}

    onToggle = (name, handler) -> handlerMap[name] = handler

    toggle = (name) -> (handlerMap[name] ? -> )()

    return {
      onToggle
      toggle
    }
