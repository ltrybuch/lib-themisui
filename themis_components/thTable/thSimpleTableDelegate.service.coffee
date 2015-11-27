angular.module 'ThemisComponents'
  .factory 'SimpleTableDelegate', (TableDelegate, $interpolate) ->
    class SimpleTableDelegate extends TableDelegate
      post: (rows) ->
        template = "<table> {{thead}} {{tbody}} </table>"
        $interpolate(template)
          thead: @generateHeaders()
          tbody: @generateBody rows

      generateHeaders: ->
        return "" unless (@headers || []).length > 0
        template = "<thead> <tr> {{headers}} </tr> </thead>"
        $interpolate(template)
          headers: @headers.map((header) => @generateHeader header).join ''

      generateHeader: (header) ->
        template = "<th> {{name}} </th>"
        $interpolate(template)
          name: header.name

      generateBody: (rows) ->
        template = "<tbody> {{cellsRow}} {{actionsRow}} </tbody>"
        $interpolate(template)
          cellsRow: @generateCellsRow rows['cells']
          actionsRow: @generateActionsRow rows['actions']

      generateCellsRow: (cellsRow) ->
        template = """<tr ng-repeat-start="{{objectReference}} in thTable.delegate.data"> {{cells}} </tr>"""
        objectReference = cellsRow.getAttribute('object-reference') || 'item'
        cells = @childrenArray(cellsRow).map((cell) => @generateCell cell).join ''
        $interpolate(template) { objectReference, cells }

      generateCell: (cell) ->
        template = "<td> {{cell}} </td>"
        $interpolate(template)
          cell: cell.innerHTML

      generateActionsRow: (actionsRow) ->
        template = "<tr ng-repeat-end> {{actions}} </tr>"
        objectReference = actionsRow.getAttribute('object-reference') || 'item'
        startColumn = parseInt(actionsRow.getAttribute('start-column')) || 1
        actions = ""
        while startColumn > 1
          actions += "<td></td>"
          startColumn--
        actions += "<td>#{actionsRow.innerHTML}</td>"
        $interpolate(template) { objectReference, actions }

      childrenArray: (node) ->
        arr = []
        arr.push(child) for child in node.children
        arr
