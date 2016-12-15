angular.module 'ThemisComponents'
  .factory 'TableHeader', -> TableHeader

TableHeader = (options = {}) ->
  {
    name = ''
    sortField
    width
    sortActive = false
    sortDirection = "ascending"
    align = "left"
    visible = true
  } = options

  if sortActive and not sortField?
    throw new Error "You need to define sortField to enable sorting."

  if sortDirection not in ["ascending", "descending"]
    throw new Error "sortDirection can be either ascending or descending."

  if align not in ["left", "center", "right"]
    throw new Error "align can be one of: left, center, or right."

  opposite = ascending: "descending", descending: "ascending"

  return {
    name
    sortField
    width
    visible

    cssClasses: ->
      classes = []
      if sortField?
        classes.push 'th-table-sortable'
      if sortActive
        classes.push "th-table-sort-" + sortDirection
      else
        classes.push "th-table-sort-none"
      classes.push "th-table-align-" + align
      return classes.join ' '

    isSortActive: -> sortActive or false

    getSortDirection: -> sortDirection

    activateSort: ->
      sortActive = true
      sortDirection = "ascending"

    deactivateSort: -> sortActive = false

    toggleSortDirection: -> sortDirection = opposite[sortDirection]
  }
