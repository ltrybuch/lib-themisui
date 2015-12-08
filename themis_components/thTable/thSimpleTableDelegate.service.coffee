angular.module 'ThemisComponents'
  .factory 'SimpleTableDelegate', (TableDelegate, $interpolate) ->
    class SimpleTableDelegate extends TableDelegate
      constructor: (options) ->
        super options
        if @hasValidPagination()
          @pages

      pages: ->
        numPages = Math.ceil @totalItems / @pageSize
        pagesArray = []
        page = 1
        while page <= numPages
          pagesArray.push page
          page++
        pagesArray

      isLastPage: ->
        @page is @pages().length

      isFirstPage: ->
        @page is 1

      isCurrentPage: (page) ->
        @page is page

      nextPage: ->
        if @page < @pages().length
          @onChangePage @page + 1

      prevPage: ->
        if @page > 1
          @onChangePage @page - 1

      onChangePage: (page) ->
        @page = page

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
        template = "<table>{{thead}}{{tbody}}</table>{{pagination}}"
        $interpolate(template)
          thead: @generateHeaders()
          tbody: @generateBody rows
          pagination: @generatePagination()

      generateHeaders: ->
        return "" unless (@headers or []).length > 0

        template = """
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
        numColumns = @childrenArray(rows['cells']).length
        $interpolate(template)
          cellsRow: @generateCellsRow rows['cells']
          actionsRow: @generateActionsRow rows['actions'], numColumns

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
        $interpolate(template) {objectReference, cells}

      generateCell: (cell) ->
        template = "<td>{{cell}}</td>"
        $interpolate(template)
          cell: cell.innerHTML

      generateActionsRow: (actionsRow, numColumns) ->
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
        if startColumn > numColumns
          throw new Error "start-column cannot be bigger " + \
                          "than the number of cells"

        colspan = numColumns - startColumn + 1

        actions = ""
        while startColumn > 1
          actions += """<td class="th-table-actions-cell"></td>"""
          startColumn--
        actions += """
          <td class="th-table-actions-cell" colspan=#{colspan}>
            #{actionsRow.innerHTML}
          </td>
        """

        $interpolate(template) {objectReference, actions}

      generatePagination: ->
        return "" unless @hasValidPagination()

        template = """
          <div class="th-table-pagination">
            <a class="th-table-pagination-link"
               ng-class="{'th-table-pagination-inactive-link': thTable.delegate.isFirstPage()}"
               ng-click="thTable.delegate.prevPage()">
              <div class="fa fa-chevron-left th-table-pagination-icon-left"></div>
              Previous
            </a>

            <a class="th-table-pagination-link"
               ng-repeat="page in thTable.delegate.pages()"
               ng-click="thTable.delegate.onChangePage(page)"
               ng-class="{'th-table-pagination-inactive-link':
                            thTable.delegate.isCurrentPage(page)}">
              {{page}}
            </a>

            <a class="th-table-pagination-link"
               ng-class="{'th-table-pagination-inactive-link': thTable.delegate.isLastPage()}"
               ng-click="thTable.delegate.nextPage()">
              Next
              <div class="fa fa-chevron-right th-table-pagination-icon-right"></div>
            </a>
          </div>
        """

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

      hasValidPagination: ->
        @page? and @pageSize? and @totalItems?

      getObjectReference: (row) ->
        row.getAttribute('object-reference') || 'item'
