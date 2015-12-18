angular.module 'ThemisComponents'
  .factory 'TableSort', -> TableSort()

TableSort = ->
  applySortOrder = (direction, compareResult) ->
    if direction is "ascending"
      compareResult
    else
      -compareResult

  compare = (a, b) ->
    if typeof a in ["number", "boolean"]
      a - b
    else
      a.localeCompare b

  getField = (object, field) ->
    return object if field is ''
    result = object
    field.split('.').forEach (key) -> result = result[key]
    return result

  return Object.freeze {
    sort: (data, header) ->
      return data unless header.isSortActive()
      return data.sort (obj1, obj2) ->
        field1 = getField obj1, header.sortField
        field2 = getField obj2, header.sortField
        result = compare field1, field2
        applySortOrder header.getSortDirection(), result
  }
