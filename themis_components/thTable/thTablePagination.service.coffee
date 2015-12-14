angular.module 'ThemisComponents'
.factory 'TablePagination', ($interpolate) ->
  interpolateStart = $interpolate.startSymbol()
  interpolateEnd = $interpolate.endSymbol()

  TablePagination = (options) ->
    {
      currentPage
      pageSize
      onChangePage
    } = options

    totalItems = 0
    dotdotdot = '...'
    maxConsecutivePages = 5

    totalPages = -> Math.ceil totalItems / pageSize

    pages = ->
      return [] unless totalItems > 0

      lastPage = totalPages()
      if lastPage <= maxConsecutivePages + 4
        return [1 .. lastPage]

      if maxConsecutivePages % 2 is 0
        start = currentPage - maxConsecutivePages / 2 + 1
        end = currentPage + maxConsecutivePages / 2
      else
        start = currentPage - Math.floor maxConsecutivePages / 2
        end = currentPage + Math.floor maxConsecutivePages / 2

      if start < 3
        end = Math.max maxConsecutivePages, end
        return [1 .. end].concat [dotdotdot, lastPage]

      if end > lastPage - 2
        start = Math.min lastPage - maxConsecutivePages + 1, start
        return [1, dotdotdot].concat [start .. lastPage]

      return [1, dotdotdot]
                .concat [start .. end]
                .concat [dotdotdot, lastPage]

    isFirstPage = ->
      currentPage is 1

    isLastPage = ->
      currentPage is totalPages()

    inactivePageLink = (page) ->
      page in [currentPage, dotdotdot]

    goToNextPage = ->
      if currentPage < totalPages()
        goToPage currentPage + 1

    goToPrevPage = ->
      if currentPage > 1
        goToPage currentPage - 1

    goToPage = (page) ->
      return if page is dotdotdot
      currentPage = page
      onChangePage()

    generatePagination = ->
      return "" unless hasValidPagination options
      template = """
        <div class="th-table-pagination" ng-if="thTable.delegate.pages().length > 1">
          <a class="th-table-pagination-link"
             ng-class="{'th-table-pagination-inactive-link': thTable.delegate.isFirstPage()}"
             ng-click="thTable.delegate.goToPrevPage()">
            <div class="fa fa-chevron-left th-table-pagination-icon-left"></div>
            Previous
          </a>

          <a class="th-table-pagination-link"
             ng-repeat="page in thTable.delegate.pages() track by $index"
             ng-click="thTable.delegate.goToPage(page)"
             ng-class="{'th-table-pagination-inactive-link':
                          thTable.delegate.inactivePageLink(page)}">
            #{interpolateStart}page#{interpolateEnd}
          </a>

          <a class="th-table-pagination-link"
             ng-class="{'th-table-pagination-inactive-link': thTable.delegate.isLastPage()}"
             ng-click="thTable.delegate.goToNextPage()">
            Next
            <div class="fa fa-chevron-right th-table-pagination-icon-right"></div>
          </a>
        </div>
      """

    hasValidPagination = ->
      options.currentPage? and options.pageSize?

    updatePagination = (options) ->
      totalItems = options.totalItems ? totalItems
      currentPage = options.currentPage ? currentPage

    getCurrentPage = -> currentPage
    getPageSize = -> pageSize

    return Object.freeze {
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
    }
