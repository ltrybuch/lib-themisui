angular.module 'ThemisComponents'
  .factory 'DisclosureManager', ->

    stateMap = {}
    disclosureToggleHandlers = {}
    disclosureContentHandlers = {}

    open = (name) ->
      stateMap[name] = true
      disclosureToggleHandlers[name].handleOpen() if disclosureToggleHandlers[name]?
      disclosureContentHandlers[name].handleOpen() if disclosureContentHandlers[name]?

    close = (name) ->
      stateMap[name] = false
      disclosureToggleHandlers[name].handleClose() if disclosureToggleHandlers[name]?
      disclosureContentHandlers[name].handleClose() if disclosureContentHandlers[name]?

    updateState = (name, state) ->
      stateMap[name] = state if state?
      if stateMap[name]?
        if stateMap[name] then open(name) else close(name)

    return {
      updateState

      registerDisclosureToggle: (name, handlers) ->
        disclosureToggleHandlers[name] = handlers
        updateState name

      registerDisclosureContent: (name, handlers) ->
        disclosureContentHandlers[name] = handlers
        updateState name
    }
