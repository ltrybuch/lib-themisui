angular.module 'ThemisComponents'
  .factory 'TableSort', -> TableSort()

TableSort = ->
  applySortOrder = (direction, compareResult) ->
    if direction is "ascending"
      compareResult
    else
      -compareResult

  compare = (a, b) ->
    if typeof a is "number"
      a - b
    else
      a.localeCompare b

  getField = (object, field) ->
    result = object
    field.split('.').forEach (key) -> result = result[key]
    result

  sort = (data, header) ->
    data.sort (obj1, obj2) ->
      field1 = getField obj1, header.sortField
      field2 = getField obj2, header.sortField
      applySortOrder header.getSortDirection(), compare(field1, field2)

  return Object.freeze {
    sort
  }
