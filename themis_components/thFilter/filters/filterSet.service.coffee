angular.module 'ThemisComponents'
.factory 'FilterSet', ->
  FilterSet = (options = {}) ->
    {
      onFilterChange
    } = options

    unless onFilterChange instanceof Function
      throw new Error "FilterSet needs to be passed the following " + \
                      "function: onFilterChange: ->"

    filterArray = []
    filterArray.onFilterChange = onFilterChange

    filterArray.remove = (filterBase) ->
      index = @indexOf filterBase
      @splice(index, 1) if index isnt -1

    filterArray.getQueryParameters = ->
      @reduce (paramsCollector, filter) ->
        paramsCollector[filter.fieldIdentifier] = filter.getValue() if filter.getValue()?
        return paramsCollector
      , {}

    filterArray.getQueryString = ->
      @reduce (queryString, filter) ->
        if filter.getValue()?
          if queryString.length > 0
            queryString = queryString + "&"
          queryString = queryString + filter.fieldIdentifier + "=" + filter.getValue()
        return queryString
      , ""

    return filterArray
