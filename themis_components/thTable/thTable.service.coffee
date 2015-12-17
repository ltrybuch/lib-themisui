angular.module 'ThemisComponents'
  .factory 'Table', -> Table

Table = (options = {}) ->
  {
    element
  } = options

  delegate = undefined

  isProperlyDefinedRow = (row) ->
    row.tagName == 'TH-TABLE-ROW' and row.hasAttribute 'type'

  isProperlyDefined = ->
    return false if element.children.length is 0
    for child in element.children
      return false unless isProperlyDefinedRow child
    true

  throw new Error "You must pass a DOM element to Table." unless element?

  throw new Error "<th-table> not properly configured!" unless isProperlyDefined()

  getRows = ->
    rows = {}
    for row in element.children
      type = row.getAttribute 'type'
      rows[type] = row
    rows

  rows = getRows()

  return Object.freeze {
    clear: -> element.removeChild element.firstChild while element.firstChild?

    setDelegate: (newDelegate) -> delegate = newDelegate

    generateTableTemplate: ->
      throw new Error "You cannot generate a template " + \
                      "before setting a delegate!" unless delegate?
      delegate.generateTableTemplate rows
  }
