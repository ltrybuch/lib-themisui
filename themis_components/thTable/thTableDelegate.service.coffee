angular.module 'ThemisComponents'
.factory 'TableDelegate', (TablePagination) ->
  TableDelegate = (options = {}) ->
    {
      headers = []
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

    reload()

    return Object.freeze {
      headers

      reload

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
      isLastPage: tablePagination.isLastPage
      isFirstPage: tablePagination.isFirstPage
      inactivePageLink: tablePagination.inactivePageLink
      goToNextPage: tablePagination.goToNextPage
      goToPrevPage: tablePagination.goToPrevPage
      goToPage: tablePagination.goToPage
      generatePaginationTemplate: tablePagination.generatePaginationTemplate
    }
