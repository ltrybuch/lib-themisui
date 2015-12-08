angular.module 'ThemisComponents'
  .factory 'SimpleTableDelegate', (TableDelegate, $interpolate) ->
    class SimpleTableDelegate extends TableDelegate
      onSort: (header) ->
        @updateHeaderSorting header

      updateHeaderSorting: (header) ->
        if header.sortEnabled
          opposite = ascending: "descending", descending: "ascending"
          header.sortEnabled = opposite[header.sortEnabled]
        else
          currentSortHeader = @headers.find (header) -> header.sortEnabled
          currentSortHeader.sortEnabled = undefined
          header.sortEnabled = "ascending"

      post: (rows) ->
        @checkValidRows rows
        template = "<table>{{thead}}{{tbody}}</table>"
        $interpolate(template)
          thead: @generateHeaders()
          tbody: @generateBody rows

      generateHeaders: ->
        return "" unless (@headers or []).length > 0

        return """
          <thead>
            <tr>
              <th ng-repeat="header in thTable.delegate.headers"
                  ng-class="header.cssClasses()"
                  ng-click="thTable.delegate.onSort(header)">
                {{header.name}}
                <span class="th-table-sort-icon" aria-hidden="true"></span>
              </th>
            </tr>
          </thead>
        """

      generateBody: (rows) ->
        template = "<tbody>{{cellsRow}}{{actionsRow}}</tbody>"
        $interpolate(template)
          cellsRow: @generateCellsRow rows['cells']
          actionsRow: @generateActionsRow rows['actions']

      generateCellsRow: (cellsRow) ->
        template = """
          <tr class="th-table-cells-row"
              ng-repeat-start="{{objectReference}} in thTable.delegate.data"
              ng-mouseover="hover = true"
              ng-mouseleave="hover = false"
              ng-class="{'th-table-hover-row': hover}">
            {{cells}}
          </tr>
        """
        objectReference = @getObjectReference cellsRow
        cells = @childrenArray(cellsRow)
                  .map (cell) => @generateCell cell
                  .join ''
        $interpolate(template) { objectReference, cells }

      generateCell: (cell) ->
        template = "<td>{{cell}}</td>"
        $interpolate(template)
          cell: cell.innerHTML

      generateActionsRow: (actionsRow) ->
        template = """
          <tr class="th-table-actions-row"
              ng-repeat-end
              ng-mouseover="hover = true"
              ng-mouseleave="hover = false"
              ng-class="{'th-table-hover-row': hover}">
            {{actions}}
          </tr>
        """
        objectReference = @getObjectReference actionsRow
        startColumn = parseInt(actionsRow.getAttribute('start-column')) || 1
        actions = ""
        while startColumn > 1
          actions += """<td class="th-table-actions-cell"></td>"""
          startColumn--
        actions += """
          <td class="th-table-actions-cell">
            #{actionsRow.innerHTML}
          </td>
        """
        $interpolate(template) { objectReference, actions }

      childrenArray: (node) ->
        arr = []
        arr.push(child) for child in node.children
        arr

      checkValidRows: (rows) ->
        if not rows["cells"]?
          throw new Error "A simple table needs a cells row."

        cellsRow = rows['cellsRow']
        actionsRow = rows['actionsRow']

        if actionsRow? and
           @getObjectReference(actionsRow) != @getObjectReference(cellsRow)
          throw new Error "object-reference must be the same" + \
                          "for the actions and cells rows."

      getObjectReference: (row) ->
        row.getAttribute('object-reference') || 'item'
