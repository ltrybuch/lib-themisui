angular.module 'ThemisComponents'
  .factory 'Table', -> Table

Table = (options = {}) ->
  {
    element
  } = options

  delegate = undefined

  getRowDefinitionErrors = (row) ->
    if row.tagName isnt 'TH-TABLE-ROW'
      return "The element's children can only be <th-table-row>s."
    if not row.hasAttribute 'type'
      return "<th-table-row>s must have the type attribute defined."
    return

  getDefinitionErrors = ->
    return "You must pass a raw DOM element to Table." unless element?
    return "The element that you passed has no children." if element.children.length is 0
    for child in element.children
      return error if error = getRowDefinitionErrors child
    return

  throw new Error error if error = getDefinitionErrors()

  getRows = ->
    rows = {}
    for row in element.children
      type = row.getAttribute 'type'
      rows[type] = row
    return rows

  rows = getRows()

  return Object.freeze {
    clear: -> element.removeChild element.firstChild while element.firstChild?

    setDelegate: (newDelegate) -> delegate = newDelegate

    generateTableTemplate: ->
      throw new Error "You cannot generate a template " + \
                      "before setting a delegate." unless delegate?
      return delegate.generateTableTemplate rows
  }
