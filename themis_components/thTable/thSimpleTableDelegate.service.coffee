angular.module 'ThemisComponents'
.factory 'SimpleTableDelegate', (TableDelegate, TablePagination, TableSort, $interpolate) ->
  SimpleTableDelegate = (options) ->
    {
      data
      headers
      onSort
      currentPage, pageSize, totalItems, onChangePage
    } = options

    updateDataFromPagination = (options) ->
      data = options.data ? data

    {
      pages
      isLastPage
      isFirstPage
      inactivePageLink
      goToNextPage
      goToPrevPage
      goToPage
      generatePagination
      updatePagination
    } = TablePagination {
      currentPage
      pageSize
      totalItems
      onChangePage
      updateData: updateDataFromPagination
    }

    updateDataFromSort = (options) ->
      data = options.data ? data
      updatePagination {totalItems: options.totalItems} if options.totalItems?

    {sort} = TableSort {
      data
      headers
      onSort
      updateData: updateDataFromSort
    }

    sortData = (header) ->
      updatePagination {currentPage: 1}
      sort data, header

    post = (rows) ->
      checkValidRows rows
      template = "<table>{{thead}}{{tbody}}</table>{{pagination}}"
      $interpolate(template)
        thead: generateHeaders()
        tbody: generateBody rows
        pagination: generatePagination()

    generateHeaders = ->
      return "" unless (headers or []).length > 0
      template = """
        <thead>
          <tr>
            <th ng-repeat="header in thTable.delegate.headers"
                ng-class="header.cssClasses()"
                ng-click="thTable.delegate.sortData(header)">
              {{header.name}}
              <span class="th-table-sort-icon" aria-hidden="true"></span>
            </th>
          </tr>
        </thead>
      """

    generateBody = (rows) ->
      template = "<tbody>{{cellsRow}}{{actionsRow}}</tbody>"
      numColumns = childrenArray(rows['cells']).length
      $interpolate(template)
        cellsRow: generateCellsRow rows['cells'], rows['actions']?
        actionsRow: generateActionsRow rows['actions'], numColumns

    generateCellsRow = (cellsRow, hasActionsRow) ->
      template = """
        <tr class="th-table-cells-row"
            {{ngRepeat}}="{{objectReference}} in thTable.delegate.getData()"
            ng-mouseover="hover = true"
            ng-mouseleave="hover = false"
            ng-class="{'th-table-hover-row': hover}">
          {{cells}}
        </tr>
      """
      ngRepeat = if hasActionsRow then "ng-repeat-start" else "ng-repeat"
      objectReference = getObjectReference cellsRow
      cells = childrenArray(cellsRow)
                .map (cell) -> generateCell cell
                .join ''
      $interpolate(template) {objectReference, cells, ngRepeat}

    generateCell = (cell) ->
      template = "<td>{{cell}}</td>"
      $interpolate(template)
        cell: cell.innerHTML

    generateActionsRow = (actionsRow, numColumns) ->
      return "" unless actionsRow?
      template = """
        <tr class="th-table-actions-row"
            ng-repeat-end
            ng-mouseover="hover = true"
            ng-mouseleave="hover = false"
            ng-class="{'th-table-hover-row': hover}">
          {{actions}}
        </tr>
      """
      objectReference = getObjectReference actionsRow

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

    checkValidRows = (rows) ->
      if not rows["cells"]?
        throw new Error "A simple table needs a cells row."

      cellsRow = rows['cellsRow']
      actionsRow = rows['actionsRow']

      if actionsRow? and
         getObjectReference(actionsRow) != getObjectReference(cellsRow)
        throw new Error "object-reference must be the same" + \
                        "for the actions and cells rows."

    childrenArray = (node) ->
      arr = []
      arr.push(child) for child in node.children
      arr

    getObjectReference = (row) ->
      row.getAttribute('object-reference') || 'item'

    getData = -> data

    return Object.freeze {
      post
      getData
      headers
      sortData
      pages
      isLastPage
      isFirstPage
      inactivePageLink
      goToNextPage
      goToPrevPage
      goToPage
    }
