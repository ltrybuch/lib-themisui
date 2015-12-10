angular.module 'ThemisComponents'
  .factory 'SimpleTableDelegate', (TableDelegate, $interpolate) ->
    class SimpleTableDelegate extends TableDelegate
      constructor: (options) ->
        super options

      totalPages: ->
        Math.ceil @totalItems / @pageSize

      pages: ->
        maxConsecutivePages = 5
        totalPages = @totalPages()

        if totalPages <= maxConsecutivePages + 4
          return [1 .. totalPages]

        if maxConsecutivePages % 2 is 0
          start = @page - maxConsecutivePages / 2 + 1
          end = @page + maxConsecutivePages / 2
        else
          start = @page - Math.floor maxConsecutivePages / 2
          end = @page + Math.floor maxConsecutivePages / 2

        if start < 3
          end = Math.max maxConsecutivePages, end
          return [1 .. end].concat ['...', totalPages]

        if end > totalPages - 2
          start = Math.min totalPages - maxConsecutivePages + 1, start
          return [1, '...'].concat [start .. totalPages]

        return [1, '...']
                  .concat [start .. end]
                  .concat ['...', totalPages]

      isLastPage: ->
        @page is @totalPages()

      isFirstPage: ->
        @page is 1

      inactivePageLink: (page) ->
        page in [@page, '...']

      nextPage: ->
        if @page < @totalPages()
          @changePage @page + 1

      prevPage: ->
        if @page > 1
          @changePage @page - 1

      changePage: (page) ->
        return if page is '...'
        @page = page
        @onChangePage page, (data) =>
          if data? then @data = data

      onChangePage: (page, next) -> next()

      sort: (header) ->
        return if not header.sortField
        @updateHeaderSorting header
        (@onSort or @applyDefaultSort.bind this) header

      applyDefaultSort: (header) ->
        applySortOrder = (compareResult) ->
          if header.sortEnabled is "ascending"
            compareResult
          else
            -compareResult

        compare = (a, b) ->
          if typeof a is "number"
            a - b
          else
            a.localeCompare b

        getField = (object, field) ->
          result = object
          field.split('.').forEach (key) -> result = result[key]
          result

        @data.sort (obj1, obj2) ->
          field1 = getField obj1, header.sortField
          field2 = getField obj2, header.sortField
          applySortOrder compare(field1, field2)

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
                  ng-click="thTable.delegate.sort(header)">
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
               ng-repeat="page in thTable.delegate.pages() track by $index"
               ng-click="thTable.delegate.changePage(page)"
               ng-class="{'th-table-pagination-inactive-link':
                            thTable.delegate.inactivePageLink(page)}">
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
