angular.module 'ThemisComponents'
  .factory 'TableSort', -> TableSort

TableSort = (options) ->
  {
    headers
    onSort
    updateData
  } = options

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

  defaultSort = (data, header) ->
    data.sort (obj1, obj2) ->
      field1 = getField obj1, header.sortField
      field2 = getField obj2, header.sortField
      applySortOrder header.sortEnabled, compare(field1, field2)
    updateData {data}

  sort = (data, header) ->
    return if not header.sortField
    updateHeaderSorting header
    if onSort?
      onSort header, updateData
    else
      defaultSort data, header

  updateHeaderSorting = (header) ->
    if header.sortEnabled
      opposite = ascending: "descending", descending: "ascending"
      header.sortEnabled = opposite[header.sortEnabled]
    else
      currentSortHeader = headers.find (header) -> header.sortEnabled
      currentSortHeader.sortEnabled = undefined
      header.sortEnabled = "ascending"

  return Object.freeze {
    sort
  }
