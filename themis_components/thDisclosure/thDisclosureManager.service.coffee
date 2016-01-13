angular.module 'ThemisComponents'
  .factory 'DisclosureManager', ->

    stateMap = {}
    disclosureToggleHandlers = {}
    disclosureContentHandlers = {}

    toggle = (name) ->
      if stateMap[name]?
        if stateMap[name] then close(name) else open(name)

    open = (name) ->
      stateMap[name] = true
      disclosureToggleHandlers[name].handleOpen() if disclosureToggleHandlers[name]?
      disclosureContentHandlers[name].handleOpen() if disclosureContentHandlers[name]?

    close = (name) ->
      stateMap[name] = false
      disclosureToggleHandlers[name].handleClose() if disclosureToggleHandlers[name]?
      disclosureContentHandlers[name].handleClose() if disclosureContentHandlers[name]?

    updateDisclosure = (name) ->
      if stateMap[name]?
        if stateMap[name] then open(name) else close(name)

    registerDisclosureToggle = (name, handlers) ->
      disclosureToggleHandlers[name] = handlers
      updateDisclosure name

    registerDisclosureContent = (name, handlers) ->
      disclosureContentHandlers[name] = handlers
      updateDisclosure name

    return {
      open
      close
      toggle
      registerDisclosureToggle
      registerDisclosureContent
    }
