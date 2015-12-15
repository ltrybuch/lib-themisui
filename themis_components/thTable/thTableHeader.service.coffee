angular.module 'ThemisComponents'
  .factory 'TableHeader', -> TableHeader

TableHeader = (options) ->
  {
    name
    sortField
    sortActive
    sortDirection
    align = "left"
  } = options

  if sortActive and not sortDirection?
    throw new Error "sortDirection must be set for the active sort header"

  if sortDirection? and sortDirection not in ["ascending", "descending"]
    throw new Error "sortDirection can be either ascending or descending"

  if align not in ["left", "center", "right"]
    throw new Error "align can be one of: left, center or right"

  opposite = ascending: "descending", descending: "ascending"

  return Object.freeze {
    name
    sortField

    cssClasses: ->
      classes = []
      if sortField?
        classes.push 'th-table-sortable'
      if sortActive
        classes.push "th-table-sort-" + sortDirection
      else
        classes.push "th-table-sort-none"
      classes.push "th-table-align-" + align
      classes.join ' '

    isSortActive: -> sortActive

    activateSort: ->
      sortActive = true
      sortDirection = "ascending"

    deactivateSort: ->
      sortActive = false
      sortDirection = undefined

    toggleSortDirection: -> sortDirection = opposite[sortDirection]

    getSortDirection: -> sortDirection
  }
