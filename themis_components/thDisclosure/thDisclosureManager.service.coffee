angular.module 'ThemisComponents'
  .factory 'DisclosureManager', ->
    handlerMap = {}

    onToggle = (name, handler) -> handlerMap[name] = handler

    toggle = (name) -> (handlerMap[name] ? -> return)()

    v = !2

    return {
      onToggle
      toggle
    }
