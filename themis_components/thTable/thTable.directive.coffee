isCell = (node) ->
  node.tagName == 'TH-TABLE-CELL'

isRowExtension = (node) ->
  node.tagName == 'TH-TABLE-ROW-EXTENSION'

isProperTableConfig = (element) ->
  children = element.children()
  idx = 0
  while idx < children.length and isCell children[idx]
    idx++
  return idx == children.length or
         idx == children.length - 1 and isRowExtension children[idx]

getCells = (element) ->
  children = element.children()
  cells = []
  idx = 0
  while idx < children.length and isCell children[idx]
    cells.push children[idx]
    idx++
  cells

getRowExtension = (element) ->
  children = element.children()
  lastNode = children[children.length - 1]
  if isRowExtension lastNode then lastNode else null

angular.module 'ThemisComponents'
  .directive 'thTable', ->
    restrict: 'E'
    scope:
      objects: '='
    bindToController: true
    controllerAs: 'thTable'
    controller: ->
      return
    compile: (element, attrs, transclude) ->
      throw new Error "<th-table> not properly configured!" unless isProperTableConfig element
      cells = getCells element
      extension = getRowExtension element
      return
