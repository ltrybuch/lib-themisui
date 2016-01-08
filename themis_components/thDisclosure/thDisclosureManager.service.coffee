angular.module 'ThemisComponents'
  .factory 'DisclosureManager', ($q) ->

    stateMap = {}
    disclosureToggles = {}
    disclosureContents = {}

    toggle = (name) ->
      if stateMap[name]?
        if stateMap[name] then close(name) else open(name)

    open = (name) ->
      stateMap[name] = true
      disclosureToggles[name].open() if disclosureToggles[name]?
      disclosureContents[name].open() if disclosureContents[name]?

    close = (name) ->
      stateMap[name] = false
      disclosureToggles[name].close() if disclosureToggles[name]?
      disclosureContents[name].close() if disclosureContents[name]?

    updateDisclosure = (name) ->
      if stateMap[name]?
        if stateMap[name] then open(name) else close(name)

    registerDisclosureToggle = (name, obj) ->
      disclosureToggles[name] = obj
      updateDisclosure name

    registerDisclosureContent = (name, obj) ->
      disclosureContents[name] = obj
      updateDisclosure name

    return {
      open
      close
      toggle
      registerDisclosureToggle
      registerDisclosureContent
    }
