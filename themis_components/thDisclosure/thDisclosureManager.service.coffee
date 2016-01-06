angular.module 'ThemisComponents'
  .factory 'DisclosureManager', ($q) ->
    handlerMap = {}
    stateMap = {}

    onToggle = (name, handler) -> handlerMap[name] = handler

    toggle = (name) -> (handlerMap[name] ? -> return)()

    setDefaultState = (name, state) ->
      if stateMap[name]?
        stateMap[name].resolve(state)
      else
        deferred = $q.defer()
        deferred.resolve(state)
        stateMap[name] = deferred.promise

    getDefaultState = (name) ->
      if stateMap[name]?
        stateMap[name]
      else
        deferred = $q.defer()
        stateMap[name] = deferred.promise
        deferred.promise

    return {
      onToggle
      toggle
      getDefaultState
      setDefaultState
    }
