angular.module "ThemisComponents"
.factory "TableDelegate", (TablePagination, TableFooter) ->
  TableDelegate = (options = {}) ->
    {
      headers = []
      footers = []
      currentPage
      pageSize
      fetchData
    } = options

    throw new Error "TableDelegate needs to be passed the following function: " + \
                    "fetchData: (options, updateData) ->" unless fetchData instanceof Function

    data = []
    loading = false
    error = false
    currentSortHeader = headers.find (header) -> header.isSortActive()

    reload = (options = {}) ->
      loading = true
      error = false

      if options.currentPage?
        updatePagination {currentPage: options.currentPage}

      updateData = (options = {}) ->
        newError = options.error
        newData = options.data ? []
        totalItems = options.totalItems

        loading = false

        if newError?
          error = newError
        else
          data = newData
          updatePagination {totalItems} if totalItems?

      fetchData {
        currentPage: getCurrentPage()
        pageSize: getPageSize()
        sortHeader: currentSortHeader
      }, updateData

    tablePagination = TablePagination {currentPage, pageSize, reload}

    {
      updatePagination
      getCurrentPage
      getPageSize
    } = tablePagination

    updateHeaderSorting = (newSortHeader) ->
      if newSortHeader.isSortActive()
        newSortHeader.toggleSortDirection()
      else
        newSortHeader.activateSort()
        currentSortHeader.deactivateSort() if currentSortHeader?
        currentSortHeader = newSortHeader

    setVisibleColumns = (visibleColumns) ->
      unless visibleColumns.length is headers.length
        throw new Error "Array length does not match the number of columns."
      visibleColumns.forEach (visibility, index) ->
        headers[index]?.visible = visibility
        footers[index]?.visible = visibility

    generateFooterColumns = ->
      return [] unless footers.length > 0
      footersNeeded = headers.length
      allFooters = [0...footersNeeded].map -> TableFooter()
      footers.forEach (footer) -> allFooters[footer.column - 1] = footer.footer
      return allFooters

    footers = generateFooterColumns()

    updateFooters = (footerColumns) ->
      footerColumns.forEach (footer) ->
        footers[footer.column - 1]?.value = footer.value

    reload()

    return Object.freeze {
      headers

      footers

      reload

      setVisibleColumns

      updateFooters

      getData: -> data

      getError: -> error

      isLoading: -> loading

      hasNoData: -> data.length is 0 and not loading and not error

      sortData: (header) ->
        return unless header.sortField?
        updatePagination {currentPage: 1}
        updateHeaderSorting header
        reload()

      pages: tablePagination.pages
      totalRecords: tablePagination.getTotalRecordCount
      isLastPage: tablePagination.isLastPage
      isFirstPage: tablePagination.isFirstPage
      inactivePageLink: tablePagination.inactivePageLink
      goToNextPage: tablePagination.goToNextPage
      goToPrevPage: tablePagination.goToPrevPage
      goToPage: tablePagination.goToPage
      generatePaginationTemplate: tablePagination.generatePaginationTemplate
    }
