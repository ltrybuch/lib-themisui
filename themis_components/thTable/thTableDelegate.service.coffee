angular.module 'ThemisComponents'
.factory 'TableDelegate', (TablePagination) ->
  SimpleTableDelegate = (options) ->
    {
      headers
      currentPage
      pageSize
      fetchData
    } = options

    data = []
    loading = false
    error = false

    currentSortHeader = (headers ? []).find (header) -> header.isSortActive()

    triggerFetchData = ->
      loading = true
      error = false
      currentPage = getCurrentPage()
      pageSize = getPageSize()
      fetchData currentPage, pageSize, currentSortHeader, (err, newData, totalItems) ->
        loading = false
        if err
          error = err
        else
          data = newData or []
          updatePagination {totalItems} if totalItems?

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
      getCurrentPage
      getPageSize
    } = TablePagination {
      currentPage
      pageSize
      onChangePage: triggerFetchData
    }

    sortData = (header) ->
      return if not header.sortField
      updatePagination {currentPage: 1}
      updateHeaderSorting header
      triggerFetchData()

    updateHeaderSorting = (newSortHeader) ->
      if newSortHeader.isSortActive()
        newSortHeader.toggleSortDirection()
      else
        newSortHeader.activateSort()
        currentSortHeader.deactivateSort()
        currentSortHeader = newSortHeader

    getData = -> data
    getError = -> error
    isLoading = -> loading

    triggerFetchData()

    return Object.freeze {
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
      getError
      isLoading
      generatePagination
      triggerFetchData
    }
