context = describe
describe 'ThemisComponents: Service: thTablePagination', ->
  TablePagination = null
  ellipsis = '...'

  beforeEach ->
    module 'ThemisComponents'

    inject (_TablePagination_, _TableHeader_) ->
      TablePagination = _TablePagination_

  it 'exists', ->
    expect(TablePagination?).toBe true

  describe '#constructor', ->
    it 'exposes currentPage and pageSize', ->
      currentPage = 1
      pageSize = 5
      pagination = TablePagination {currentPage, pageSize}
      expect(pagination.getCurrentPage()).toBe currentPage
      expect(pagination.getPageSize()).toBe pageSize

  describe '#pages', ->
    it 'always shows first and last page and 2 pages around the current page', ->
      pageSize = 5

      pagesAround = (currentPage, lastPage) ->
        start = Math.max 1, currentPage - 2
        end = Math.min lastPage, currentPage + 2
        [start .. end]

      for numPages in [1 .. 20]
        for currentPage in [1 .. numPages]
          totalItems = numPages * pageSize
          pagination = TablePagination {currentPage, pageSize}
          pagination.updatePagination {totalItems}
          pages = pagination.pages()
          for page in pagesAround currentPage, numPages
            expect(pages).toContain page
          expect(pages[0]).toBe 1
          expect(pages[pages.length - 1]).toBe numPages
          expect(pages.length).toBeLessThan 10

    context '<= 9 pages', ->
      it 'shows all pages', ->
        currentPage = 1
        pageSize = 5
        for numPages in [1 .. 9]
          totalItems = numPages * pageSize
          pagination = TablePagination {currentPage, pageSize}
          pagination.updatePagination {totalItems}
          expect(pagination.pages()).toEqual [1 .. numPages]

    context '> 9 pages', ->
      it 'shows ellipsis if current page is far from first or last page', ->
        pageSize = 5
        for numPages in [10 .. 20]
          for currentPage in [1 .. numPages]
            totalItems = numPages * pageSize
            pagination = TablePagination {currentPage, pageSize}
            pagination.updatePagination {totalItems}
            pages = pagination.pages()

            if currentPage > 4
              expect(pages[1]).toEqual ellipsis
            else
              expect(pages[1]).not.toEqual ellipsis

            if currentPage < numPages - 3
              expect(pages[pages.length - 2]).toEqual ellipsis
            else
              expect(pages[pages.length - 2]).not.toEqual ellipsis

  describe '#isFirstPage', ->
    it 'returns true', ->
      currentPage = 1
      pageSize = 5
      pagination = TablePagination {currentPage, pageSize}
      expect(pagination.isFirstPage()).toBe true

    it 'returns false', ->
      currentPage = 2
      pageSize = 5
      pagination = TablePagination {currentPage, pageSize}
      expect(pagination.isFirstPage()).toBe false

  describe '#isLastPage', ->
    it 'returns false', ->
      currentPage = 1
      pageSize = 5
      numPages = 10
      totalItems = numPages * pageSize
      pagination = TablePagination {currentPage, pageSize}
      pagination.updatePagination {totalItems}
      expect(pagination.isLastPage()).toBe false

    it 'returns true', ->
      currentPage = 10
      pageSize = 5
      numPages = 10
      totalItems = numPages * pageSize
      pagination = TablePagination {currentPage, pageSize}
      pagination.updatePagination {totalItems}
      expect(pagination.isLastPage()).toBe true

  describe '#inactivePageLink', ->
    it 'returns true', ->
      currentPage = 2
      pageSize = 5
      pagination = TablePagination {currentPage, pageSize}
      expect(pagination.inactivePageLink(2)).toBe true
      expect(pagination.inactivePageLink(ellipsis)).toBe true

  it 'returns false', ->
    currentPage = 2
    pageSize = 5
    pagination = TablePagination {currentPage, pageSize}
    expect(pagination.inactivePageLink(1)).toBe false

  describe '#goToNextPage', ->
    it 'does not work if current page is the last one', ->
      currentPage = 10
      pageSize = 5
      numPages = 10
      totalItems = numPages * pageSize
      called = false
      triggerFetchData = -> called = true
      pagination = TablePagination {currentPage, pageSize, triggerFetchData}
      pagination.updatePagination {totalItems}
      pagination.goToNextPage()
      expect(pagination.getCurrentPage()).toBe currentPage
      expect(called).toBe false

    it 'increases currentPage and calls triggerFetchData', ->
      currentPage = 9
      pageSize = 5
      numPages = 10
      totalItems = numPages * pageSize
      called = false
      triggerFetchData = -> called = true
      pagination = TablePagination {currentPage, pageSize, triggerFetchData}
      pagination.updatePagination {totalItems}
      pagination.goToNextPage()
      expect(pagination.getCurrentPage()).toBe currentPage + 1
      expect(called).toBe true

  describe '#goToPrevPage', ->
    it 'does not work if current page is the first one', ->
      currentPage = 1
      pageSize = 5
      numPages = 10
      totalItems = numPages * pageSize
      called = false
      triggerFetchData = -> called = true
      pagination = TablePagination {currentPage, pageSize, triggerFetchData}
      pagination.updatePagination {totalItems}
      pagination.goToPrevPage()
      expect(pagination.getCurrentPage()).toBe currentPage
      expect(called).toBe false

    it 'decreases currentPage and calls triggerFetchData', ->
      currentPage = 9
      pageSize = 5
      numPages = 10
      totalItems = numPages * pageSize
      called = false
      triggerFetchData = -> called = true
      pagination = TablePagination {currentPage, pageSize, triggerFetchData}
      pagination.updatePagination {totalItems}
      pagination.goToPrevPage()
      expect(pagination.getCurrentPage()).toBe currentPage - 1
      expect(called).toBe true

  describe '#goToPage', ->
    it 'does not work if called with invalid page', ->
      currentPage = 1
      pageSize = 5
      numPages = 10
      totalItems = numPages * pageSize
      called = false
      triggerFetchData = -> called = true
      pagination = TablePagination {currentPage, pageSize, triggerFetchData}
      pagination.updatePagination {totalItems}

      pagination.goToPage 0
      expect(pagination.getCurrentPage()).toBe currentPage
      expect(called).toBe false

      pagination.goToPage 1
      expect(pagination.getCurrentPage()).toBe currentPage
      expect(called).toBe false

      pagination.goToPage ellipsis
      expect(pagination.getCurrentPage()).toBe currentPage
      expect(called).toBe false

    it 'updates currentPage and calls triggerFetchData', ->
      currentPage = 9
      pageSize = 5
      numPages = 10
      totalItems = numPages * pageSize
      called = false
      triggerFetchData = -> called = true
      pagination = TablePagination {currentPage, pageSize, triggerFetchData}
      pagination.updatePagination {totalItems}
      newPage = 5
      pagination.goToPage newPage
      expect(pagination.getCurrentPage()).toBe newPage
      expect(called).toBe true

  describe '#generatePagination', ->
    it 'returns empty template unless it has currentPage and pageSize', ->
      currentPage = 1
      pageSize = 5

      pagination = TablePagination()
      expect(pagination.generatePaginationTemplate()).toEqual ''

      pagination = TablePagination {currentPage}
      expect(pagination.generatePaginationTemplate()).toEqual ''

      pagination = TablePagination {pageSize}
      expect(pagination.generatePaginationTemplate()).toEqual ''

    it 'returns proper template if it has currentPage and pageSize', ->
      currentPage = 1
      pageSize = 5

      pagination = TablePagination {currentPage, pageSize}
      expect(pagination.generatePaginationTemplate()).not.toEqual ''

  describe '#updatePagination', ->
    it 'updates currentPage and totalItems if they exist', ->
      currentPage = 9
      pageSize = 5
      pagination = TablePagination {currentPage, pageSize}

      getNumPages = ->
        pages = pagination.pages()
        return 0 if pages.length is 0
        pages[pages.length - 1]

      expect(getNumPages()).toBe 0

      numPages = 10
      totalItems = numPages * pageSize
      pagination.updatePagination {totalItems}
      expect(getNumPages()).toBe numPages
      expect(pagination.getCurrentPage()).toBe currentPage

      newCurrentPage = 8
      pagination.updatePagination {currentPage: newCurrentPage}
      expect(getNumPages()).toBe numPages
      expect(pagination.getCurrentPage()).toBe newCurrentPage
