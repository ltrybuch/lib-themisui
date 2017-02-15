angular.module 'ThemisComponents'
.factory 'SimpleTableDelegate', (TableDelegate, $interpolate) ->
  interpolateStart = $interpolate.startSymbol()
  interpolateEnd = $interpolate.endSymbol()

  SimpleTableDelegate = (options = {}) ->
    delegate = TableDelegate options

    {
      headers = []
      footers = []
      generatePaginationTemplate
    } = delegate

    generateHeadersTemplate = ->
      return "" unless headers.length > 0
      return """
        <thead>
          <tr role="row">
            <th ng-repeat="header in thTable.delegate.headers track by $index"
                ng-class="header.cssClasses()"
                ng-if="header.visible"
                ng-click="thTable.delegate.sortData(header)"
                tabindex="0"
                role="columnheader"
                >
              #{interpolateStart}header.name#{interpolateEnd}
              <span class="th-table-sort-icon" aria-hidden="true"></span>
            </th>
          </tr>
        </thead>
      """

    generateFootersTemplate = ->
      return "" unless footers.length > 0
      return """
        <tfoot>
          <tr role="row">
            <td ng-repeat="footer in thTable.delegate.footers track by $index"
              ng-class="footer.AlignCssClass()"
              ng-if="footer.visible"
              tabindex="0"
              role="columnfooter"
              >
              #{interpolateStart}footer.value#{interpolateEnd}
            </td>
          </tr>
        </tfoot>
      """

    generateColTemplate = ->
      hasSetWidth = (headers.filter (header) -> header.width?).length > 0
      return "" unless hasSetWidth
      return headers
        .map (header, index) ->
          width = if header.width then "style='width: #{header.width}'" else ""
          """<col ng-if="thTable.delegate.headers[#{index}].visible" #{width}>"""
        .join ''

    generateBodyTemplate = (rows) ->
      numColumns = childrenArray(rows['cells']).length
      cellsRow = generateCellsRowTemplate rows['cells'], rows['actions']?
      actionsRow = generateActionsRowTemplate rows['actions'], numColumns
      noDataRow = generateNoDataRowTemplate rows['no-data'], numColumns
      errorRow = generateErrorRowTemplate numColumns
      return """
        <tbody>
          #{noDataRow}
          #{errorRow}
          #{cellsRow}
          #{actionsRow}
        </tbody>
      """

    generateCellsRowTemplate = (cellsRow, hasActionsRow) ->
      ngRepeat = if hasActionsRow then "ng-repeat-start" else "ng-repeat"
      objectReference = getObjectReference cellsRow
      cells = childrenArray(cellsRow)
                .map (cell, index) ->
                  generateCellTemplate cell, index
                .join ''

      return """
        <tr
          class="th-table-cells-row"
          #{ngRepeat}="#{objectReference} in thTable.delegate.getData()"
          ng-mouseover="thTable.mouseOver($event)"
          ng-mouseleave="thTable.mouseLeave($event)"
          role="row"
          >
          #{cells}
        </tr>
      """

    generateCellTemplate = (cell, index) ->
      return """
        <td
          ng-if="thTable.delegate.headers[#{index}].visible"
          role="gridcell"
          tabindex="-1"
          >
          #{cell.innerHTML}
        </td>
      """

    generateActionsRowTemplate = (actionsRow, numColumns) ->
      return "" unless actionsRow?
      startColumn = parseInt (actionsRow.getAttribute('start-column') ? 1), 10
      colspan = numColumns - startColumn + 1
      return """
        <tr
          class="th-table-actions-row"
          ng-repeat-end
          ng-mouseover="thTable.mouseOver($event)"
          ng-mouseleave="thTable.mouseLeave($event)"
          ng-if="thTable.delegate.headers[#{startColumn - 1}].visible"
          role="row"
          data-column-start="#{startColumn}"
          >
          <td
            class="th-table-actions-cell"
            ng-class="#{startColumn - 1} == $index ? 'has-actions' : ''"
            role="gridcell"
            ng-repeat="header in thTable.delegate.headers track by $index"
            tabindex="-1"
            aria-selected="{{focused ? 'true' : 'false'}}"
            aria-hidden="{{#{startColumn - 1} > $index}}"
            ng-if="header.visible &&
                   #{startColumn - 1} >= $index &&
                   thTable.delegate.headers[#{startColumn - 1}].visible"
            colspan="#{interpolateStart}
                       #{startColumn - 1} == $index ? #{colspan} : 1
                     #{interpolateEnd}"
            >
            <span ng-if="#{startColumn - 1} == $index">
              #{actionsRow.innerHTML}
            </span>
          </td>
        </tr>
      """

    generateNoDataRowTemplate = (noDataRow = {}, numColumns) ->
      contents = noDataRow.innerHTML ? "No Results"
      return """
        <tr
          class="th-table-no-data-row"
          ng-if="thTable.delegate.hasNoData()"
          role="row"
          >
          <td
            colspan="#{numColumns}"
            role="gridcell"
            >
            #{contents}
          </td>
        </tr>
      """

    generateErrorRowTemplate = (numColumns) ->
      return """
        <tr
          class="th-table-error-row"
          ng-if="thTable.delegate.getError()"
          role="row"
          >
          <td
            colspan="#{numColumns}"
            role="gridcell"
            >
            <th-error>
              <div>
                We had trouble loading your content.
              </div>
              <div>
                <a href ng-click="thTable.delegate.reload()">Try again</a>.
              </div>
            </th-error>
          </td>
        </tr>
      """

    checkValidRows = (rows) ->
      throw new Error "A simple table needs a cells row." unless rows["cells"]?

      cellsRow = rows['cells']
      actionsRow = rows['actions']

      if actionsRow? and
         getObjectReference(actionsRow) isnt getObjectReference(cellsRow)
        throw new Error "object-reference must be the same" + \
                        "for the actions and cells rows."

      if actionsRow?
        startColumn = parseInt (actionsRow.getAttribute('start-column') ? 1), 10
        numColumns = childrenArray(cellsRow).length
        if startColumn > numColumns or startColumn < 1
          throw new Error "start-column must have a value between 1 and " + \
                          "the total number of cells."

    childrenArray = (node) -> [].slice.call node.children

    getObjectReference = (row) -> row.getAttribute('object-reference') or 'item'

    return Object.freeze Object.assign {
      ###
      # This is the single required method that a custom delegate must implement.
      # The rest of the interface is inherited from TableDelegate.
      #
      # It receives as input a dictionary of {type: row} pairs, where the value,
      # row, is a <th-table-row type="...">...</th-table-row> DOM element
      # defined inside the <th-table> element.
      #
      # It must return the final table template that gets compiled in th-table's
      # parent scope, extended with the thTable key, which stores this table's
      # controller. This means you can use thTable.delegate in your template to
      # access the delegate's interface.
      ###
      generateTableTemplate: (rows = {}) ->
        checkValidRows rows
        thead = generateHeadersTemplate()
        tfoot = generateFootersTemplate()
        tbody = generateBodyTemplate rows
        pagination = generatePaginationTemplate()
        cols = generateColTemplate()
        return """
          <div ng-class="{'th-table-loading': thTable.delegate.isLoading(),
                          'th-table-blank': thTable.delegate.getData().length === 0}"
                          >
            <table
              class="th-table"
              role="grid"
              aria-readonly="true"
              tabindex="0"
              >
              #{cols}
              #{thead}
              #{tfoot}
              #{tbody}
            </table>

            #{pagination}

            <div class="th-table-overlay" ng-if="thTable.delegate.isLoading()">
              <th-loader class="th-table-loader" size="small">&nbsp;</th-loader>
            </div>
          </div>
        """
    }, delegate
