context = describe
describe 'ThemisComponents: Service: thTablePagination', ->
  TablePagination = null
  ellipsis = '…'

  beforeEach ->
    module 'ThemisComponents'

    inject (_TablePagination_) ->
      TablePagination = _TablePagination_

  it 'exists', ->
    expect(TablePagination?).toBe true

  describe '#constructor', ->
    it 'exposes currentPage and pageSize', ->
      currentPage = 2
      pageSize = 5
      pagination = TablePagination {currentPage, pageSize}
      expect(pagination.getCurrentPage()).toBe currentPage
      expect(pagination.getPageSize()).toBe pageSize

    it 'sets currentPage to default value 1 if undefined', ->
      pageSize = 5
      pagination = TablePagination {pageSize}
      expect(pagination.getCurrentPage()).toBe 1

    it 'sets currentPage to default value 1 if < 1', ->
      pageSize = 5
      currentPage = 0
      pagination = TablePagination {pageSize, currentPage}
      expect(pagination.getCurrentPage()).toBe 1

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
        pageSize = 5
        for numPages in [1 .. 9]
          for currentPage in [1 .. numPages]
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
      pageSize = 5
      pagination = TablePagination {pageSize}
      expect(pagination.isFirstPage()).toBe true

    it 'returns false', ->
      currentPage = 2
      pageSize = 5
      pagination = TablePagination {currentPage, pageSize}
      expect(pagination.isFirstPage()).toBe false

  describe '#isLastPage', ->
    it 'returns false', ->
      pageSize = 5
      numPages = 10
      totalItems = numPages * pageSize
      pagination = TablePagination {pageSize}
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
      reload = -> called = true
      pagination = TablePagination {currentPage, pageSize, reload}
      pagination.updatePagination {totalItems}
      pagination.goToNextPage()
      expect(pagination.getCurrentPage()).toBe currentPage
      expect(called).toBe false

    it 'increases currentPage and calls reload', ->
      currentPage = 9
      pageSize = 5
      numPages = 10
      totalItems = numPages * pageSize
      called = false
      reload = -> called = true
      pagination = TablePagination {currentPage, pageSize, reload}
      pagination.updatePagination {totalItems}
      pagination.goToNextPage()
      expect(pagination.getCurrentPage()).toBe currentPage + 1
      expect(called).toBe true

  describe '#goToPrevPage', ->
    it 'does not work if current page is the first one', ->
      pageSize = 5
      numPages = 10
      totalItems = numPages * pageSize
      called = false
      reload = -> called = true
      pagination = TablePagination {pageSize, reload}
      pagination.updatePagination {totalItems}
      pagination.goToPrevPage()
      expect(pagination.getCurrentPage()).toBe 1
      expect(called).toBe false

    it 'decreases currentPage and calls reload', ->
      currentPage = 9
      pageSize = 5
      numPages = 10
      totalItems = numPages * pageSize
      called = false
      reload = -> called = true
      pagination = TablePagination {currentPage, pageSize, reload}
      pagination.updatePagination {totalItems}
      pagination.goToPrevPage()
      expect(pagination.getCurrentPage()).toBe currentPage - 1
      expect(called).toBe true

  describe '#goToPage', ->
    it 'does not work if called with invalid page', ->
      pageSize = 5
      numPages = 10
      currentPage = 3
      totalItems = numPages * pageSize
      called = false
      reload = -> called = true
      pagination = TablePagination {currentPage, pageSize, reload}
      pagination.updatePagination {totalItems}

      pagination.goToPage 3
      expect(pagination.getCurrentPage()).toBe 3
      expect(called).toBe false

      pagination.goToPage ellipsis
      expect(pagination.getCurrentPage()).toBe 3
      expect(called).toBe false

    it 'corrects the page if it is out of bounds', ->
      pageSize = 5
      numPages = 10
      currentPage = 3
      totalItems = numPages * pageSize
      called = false
      reload = -> called = true
      pagination = TablePagination {pageSize, currentPage, reload}
      pagination.updatePagination {totalItems}

      expect(pagination.getCurrentPage()).toBe 3
      expect(called).toBe false

      called = false
      pagination.goToPage 0
      expect(pagination.getCurrentPage()).toBe 1
      expect(called).toBe true

      called = false
      pagination.goToPage 20
      expect(pagination.getCurrentPage()).toBe 10
      expect(called).toBe true

    it 'updates currentPage and calls reload', ->
      currentPage = 9
      pageSize = 5
      numPages = 10
      totalItems = numPages * pageSize
      called = false
      reload = -> called = true
      pagination = TablePagination {currentPage, pageSize, reload}
      pagination.updatePagination {totalItems}
      newPage = 5
      pagination.goToPage newPage
      expect(pagination.getCurrentPage()).toBe newPage
      expect(called).toBe true

  describe '#generatePagination', ->
    it 'returns empty template if pageSize is not set', ->
      pagination = TablePagination()
      expect(pagination.generatePaginationTemplate()).toEqual ''

    it 'returns proper template if it has pageSize', ->
      pageSize = 5

      pagination = TablePagination {pageSize}
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

    it 'corrects currentPage if < 1', ->
      pageSize = 5
      currentPage = 0
      reload = -> return
      pagination = TablePagination {currentPage, pageSize, reload}
      expect(pagination.getCurrentPage()).toBe 1
      pagination.updatePagination {currentPage: -1}
      expect(pagination.getCurrentPage()).toBe 1

    it 'corrects currentPage if > last page', ->
      pageSize = 5
      currentPage = 20
      numPages = 10
      totalItems = numPages * pageSize
      reload = -> return
      pagination = TablePagination {currentPage, pageSize, reload}
      expect(pagination.getCurrentPage()).toBe 20
      pagination.updatePagination {totalItems}
      expect(pagination.getCurrentPage()).toBe 10
      pagination.updatePagination {currentPage: 0}
      expect(pagination.getCurrentPage()).toBe 1
