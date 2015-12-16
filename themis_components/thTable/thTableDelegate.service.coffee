angular.module 'ThemisComponents'
.factory 'TableDelegate', (TablePagination) ->
  SimpleTableDelegate = (options) ->
    {
      headers = []
      currentPage
      pageSize
      fetchData
    } = options

    data = []
    loading = false
    error = false
    currentSortHeader = headers.find (header) -> header.isSortActive()

    triggerFetchData = ->
      loading = true
      error = false

      updateData = (options) ->
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

    tablePagination = TablePagination {currentPage, pageSize, triggerFetchData}

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
        currentSortHeader.deactivateSort()
        currentSortHeader = newSortHeader

    triggerFetchData()

    return Object.freeze {
      headers

      triggerFetchData

      getData: -> data

      getError: -> error

      isLoading: -> loading

      hasNoData: -> data.length is 0 and not loading and not error

      sortData: (header) ->
        return unless header.sortField?
        updatePagination {currentPage: 1}
        updateHeaderSorting header
        triggerFetchData()

      pages: tablePagination.pages
      isLastPage: tablePagination.isLastPage
      isFirstPage: tablePagination.isFirstPage
      inactivePageLink: tablePagination.inactivePageLink
      goToNextPage: tablePagination.goToNextPage
      goToPrevPage: tablePagination.goToPrevPage
      goToPage: tablePagination.goToPage
      generatePaginationTemplate: tablePagination.generatePaginationTemplate
    }
