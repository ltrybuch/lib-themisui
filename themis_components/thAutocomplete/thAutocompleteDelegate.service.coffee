angular.module 'ThemisComponents'
.factory 'AutocompleteDelegate', ->
  AutocompleteDelegate = (options = {}) ->
    {
      fetchData
    } = options

    throw new Error "TableDelegate needs to be passed the following function: " + \
                    "fetchData: (options, updateData) ->" unless fetchData instanceof Function

    return Object.freeze {
      fetchData
    }
