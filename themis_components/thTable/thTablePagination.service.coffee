angular.module 'ThemisComponents'
.factory 'TablePagination', ($interpolate) ->
  interpolateStart = $interpolate.startSymbol()
  interpolateEnd = $interpolate.endSymbol()

  TablePagination = (options = {}) ->
    {
      currentPage = 1
      pageSize
      reload
    } = options

    currentPage = 1 if currentPage < 1

    totalItems = 0
    ellipsis = '…'
    maxConsecutivePages = 5

    totalPages = -> Math.ceil totalItems / pageSize

    paginationEnabled = -> options.pageSize?

    return self = Object.freeze {
      # Example return value when there are 20 pages and currentPage is 9:
      # [1, '…', 7, 8, 9, 10, 11, '…', 20]
      pages: ->
        return [] unless totalItems > 0

        lastPage = totalPages()

        # 4 here means:
        #  - 1 and ellipsis at the beginning
        #  - ellipsis and lastPage at the end
        if lastPage <= maxConsecutivePages + 4
          return [1 .. lastPage]

        if maxConsecutivePages % 2 is 0
          start = currentPage - maxConsecutivePages / 2 + 1
          end = currentPage + maxConsecutivePages / 2
        else
          start = currentPage - Math.floor maxConsecutivePages / 2
          end = currentPage + Math.floor maxConsecutivePages / 2

        if start < 3
          # We don't need to display an ellipsis after 1
          end = Math.max maxConsecutivePages, end
          return [1 .. end].concat [ellipsis, lastPage]

        if end > lastPage - 2
          # We don't need to display an ellipsis before lastPage
          start = Math.min lastPage - maxConsecutivePages + 1, start
          return [1, ellipsis].concat [start .. lastPage]

        return [1, ellipsis]
                  .concat [start .. end]
                  .concat [ellipsis, lastPage]

      isFirstPage: -> currentPage is 1

      isLastPage: -> currentPage is totalPages()

      inactivePageLink: (page) -> page in [currentPage, ellipsis]

      goToNextPage: -> self.goToPage currentPage + 1

      goToPrevPage: -> self.goToPage currentPage - 1

      goToPage: (page) ->
        return if page in [ellipsis, currentPage]

        if page < 1
          page = 1
        else if totalPages() isnt 0 and page > totalPages()
          page = totalPages()

        return if page is currentPage

        currentPage = page
        reload()

      generatePaginationTemplate: ->
        return "" unless paginationEnabled options
        return """
          <div
            class="th-table-pagination"
            ng-if="thTable.delegate.pages().length > 1"
            tabindex="0"
            aria-label="Table pagination"
            >
            <a
              class="th-table-pagination-link"
              ng-class="{'th-table-pagination-inactive-link': thTable.delegate.isFirstPage()}"
              ng-click="thTable.delegate.goToPrevPage()"
              tabindex="0"
              aria-label="Previous page"
              >
              <div class="fa fa-chevron-left th-table-pagination-icon-left"></div>
              Previous
            </a>

            <a class="th-table-pagination-link"
               tabindex="-1"
               aria-label="Page #{interpolateStart}page#{interpolateEnd}"
               aria-hidden="#{interpolateStart}page == '…'#{interpolateEnd}"
               ng-repeat="page in thTable.delegate.pages() track by $index"
               ng-click="thTable.delegate.goToPage(page)"
               ng-class="{'th-table-pagination-inactive-link':
                            thTable.delegate.inactivePageLink(page)}">
              #{interpolateStart}page#{interpolateEnd}
            </a>

            <a class="th-table-pagination-link"
               ng-class="{'th-table-pagination-inactive-link': thTable.delegate.isLastPage()}"
               ng-click="thTable.delegate.goToNextPage()"
               tabindex="-1"
               aria-label="Next page"
               >
              Next
              <div class="fa fa-chevron-right th-table-pagination-icon-right"></div>
            </a>
          </div>
        """

      updatePagination: (options) ->
        totalItems = options.totalItems ? totalItems
        currentPage = options.currentPage ? currentPage
        if currentPage < 1
          currentPage = 1
        else if totalPages() isnt 0 and currentPage > totalPages()
          currentPage = totalPages()
          reload()

      getCurrentPage: -> currentPage

      getPageSize: -> pageSize

      getTotalRecordCount: -> totalItems
    }
