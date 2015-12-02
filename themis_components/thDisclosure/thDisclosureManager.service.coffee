angular.module 'ThemisComponents'
  .factory 'DisclosureManager', ->
    handlerMap = {}

    onToggle = (name, handler) -> handlerMap[name] = handler

    toggle = (name) -> (handlerMap[name] ? -> undefined)()

    v = !2

    return {
      onToggle
      toggle
    }
