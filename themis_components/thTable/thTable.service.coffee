angular.module 'ThemisComponents'
  .factory 'Table', -> Table

Table = (options) ->
  {
    element
  } = options

  isProperlyDefinedRow = (node) ->
    node.tagName == 'TH-TABLE-ROW' and node.hasAttribute 'type'

  isProperlyDefined = ->
    for child in element.children()
      return false if not isProperlyDefinedRow child
    true

  throw new Error "<th-table> not properly configured!" unless isProperlyDefined()

  delegate = undefined
  setDelegate = (newDelegate) ->
    delegate = newDelegate

  getRows = ->
    rows = {}
    for row in element.children()
      type = row.getAttribute 'type'
      rows[type] = row
    rows

  rows = getRows()

  generateTableTemplate = ->
    throw new Error "You cannot generate template before setting a delegate!" unless delegate
    delegate.generateTableTemplate rows

  clear = ->
    child.remove() for child in element.children()

  return Object.freeze {
    clear
    setDelegate
    generateTableTemplate
  }
