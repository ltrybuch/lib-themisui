angular.module 'ThemisComponents'
  .factory 'SimpleTableDelegate', (TableDelegate, $interpolate) ->
    class SimpleTableDelegate extends TableDelegate
      post: (rows) ->
        @checkValidRows rows
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
        objectReference = @getObjectReference cellsRow
        cells = @childrenArray(cellsRow).map((cell) => @generateCell cell).join ''
        $interpolate(template) { objectReference, cells }

      generateCell: (cell) ->
        template = "<td> {{cell}} </td>"
        $interpolate(template)
          cell: cell.innerHTML

      generateActionsRow: (actionsRow) ->
        template = "<tr ng-repeat-end> {{actions}} </tr>"
        objectReference = @getObjectReference actionsRow
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

      checkValidRows: (rows) ->
        throw new Error "A simple table needs a cells row." unless rows["cells"]?
        cellsRow = rows['cellsRow']
        actionsRow = rows['actionsRow']
        if actionsRow? and @getObjectReference(actionsRow) != @getObjectReference(cellsRow)
          throw new Error "The object reference for the actions and cells rows must match."

      getObjectReference: (row) ->
        row.getAttribute('object-reference') || 'item'