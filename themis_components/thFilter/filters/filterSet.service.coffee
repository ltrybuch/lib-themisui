angular.module 'ThemisComponents'
.factory 'FilterSet', ->
  FilterSet = (options = {}) ->
    {
      onFilterChange
      onInitialized
    } = options

    unless onFilterChange instanceof Function
      throw new Error "FilterSet needs to be passed the following " + \
                      "function: onFilterChange: ->"

    filterArray = []
    filterArray.onFilterChange = onFilterChange
    filterArray.onInitialized = onInitialized

    filterArray.remove = (filterBase) ->
      index = @indexOf filterBase
      @splice(index, 1) if index isnt -1

    filterArray.getState = ->
      @reduce (paramsCollector, filter) ->
        if state = filter.getState()
          paramsCollector[filter.fieldIdentifier] = state
        return paramsCollector
      , {}

    filterArray.getMetadata = ->
      @reduce (paramsCollector, filter) ->
        if metadata = filter.getMetadata()
          paramsCollector[filter.fieldIdentifier] = metadata
        return paramsCollector
      , {}

    return filterArray
