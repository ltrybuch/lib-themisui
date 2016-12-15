context = describe
describe 'ThemisComponents: Service: thTableDelegate', ->
  TableDelegate = TableHeader = null

  beforeEach angular.mock.module 'ThemisComponents'
  beforeEach inject (_TableDelegate_, _TableHeader_) ->
    TableDelegate = _TableDelegate_
    TableHeader = _TableHeader_

  it 'exists', ->
    expect(TableDelegate?).toBe true

  describe '#constructor', ->
    fetchData = 2
    it 'throws unless fetchData is a function', ->
      expect(-> TableDelegate {fetchData}).toThrow()

    it 'exposes headers', ->
      fetchData = -> return

      delegate = TableDelegate {fetchData}
      expect(delegate.headers).toEqual []

      headers = [TableHeader(), TableHeader()]
      delegate = TableDelegate {fetchData, headers}
      expect(delegate.headers).toEqual headers

    it 'calls fetchData with pagination options', ->
      currentPage = 2
      pageSize = 1
      called = false
      fetchData = (options, updateData) ->
        expect(options.currentPage).toBe currentPage
        expect(options.pageSize).toBe pageSize
        called = true
      delegate = TableDelegate {fetchData, currentPage, pageSize}
      expect(called).toBe true

    it 'calls fetchData with sort options', ->
      called = false
      headers = [
        TableHeader {sortField: ''}
        TableHeader {sortField: '', sortActive: true}
      ]
      fetchData = (options, updateData) ->
        expect(options.sortHeader).toBe headers[1]
        called = true
      delegate = TableDelegate {fetchData, headers}
      expect(called).toBe true

    it 'calls fetchData again with last page if currentPage > last page', ->
      timesCalled = 0
      currentPage = 20
      pageSize = 5
      numPages = 10
      totalItems = pageSize * numPages
      currentPageFromFetchData = undefined
      headers = [
        TableHeader {sortField: ''}
        TableHeader {sortField: '', sortActive: true}
      ]
      fetchData = (options, updateData) ->
        timesCalled += 1
        currentPageFromFetchData = options.currentPage
        updateData {totalItems}
      delegate = TableDelegate {fetchData, headers, currentPage, pageSize}
      expect(timesCalled).toBe 2
      expect(currentPageFromFetchData).toBe numPages

  describe '#reload', ->
    it 'sets loading to true and error to false', ->
      fetchData = -> return
      delegate = TableDelegate {fetchData}
      expect(delegate.isLoading()).toBe true
      expect(delegate.getError()).toBe false

    it 'sets loading to false after the updateData callback is called', ->
      fetchData = (options, updateData) -> updateData()
      delegate = TableDelegate {fetchData}
      expect(delegate.isLoading()).toBe false

    it 'sets the error from the updateData callback', ->
      fetchData = (options, updateData) ->
        updateData {error: true}
      delegate = TableDelegate {fetchData}
      expect(delegate.getError()).toBe true

    it 'sets the data from the updateData callback', ->
      data = [1, 2, 3]
      fetchData = (options, updateData) -> updateData {data}
      delegate = TableDelegate {fetchData}
      expect(delegate.getError()).toBe false
      expect(delegate.getData()).toEqual data

    it 'sets the totalItems from the updateData callback', ->
      pageSize = 5
      numPages = 10
      totalItems = numPages * pageSize
      fetchData = (options, updateData) -> updateData {totalItems}
      delegate = TableDelegate {fetchData, pageSize}
      pages = delegate.pages()
      expect(pages[pages.length - 1]).toBe numPages

    it 'calls fetchData', ->
      numCalled = 0
      fetchData = -> numCalled++
      delegate = TableDelegate {fetchData}
      expect(numCalled).toBe 1
      delegate.reload()
      expect(numCalled).toBe 2

    it 'calls fetchData and changes currentPage', ->
      page = null
      fetchData = ({currentPage}) -> page = currentPage
      delegate = TableDelegate {fetchData}
      expect(page).toBe 1
      delegate.reload({currentPage: 200})
      expect(page).toBe 200

  describe '#hasNoData', ->
    it 'is false while loading is true', ->
      fetchData = -> return
      delegate = TableDelegate {fetchData}
      expect(delegate.hasNoData()).toBe false

    it 'is false while error is true', ->
      fetchData = (options, updateData) -> updateData {error: true}
      delegate = TableDelegate {fetchData}
      expect(delegate.hasNoData()).toBe false

    it 'is false when the delegate has data', ->
      fetchData = (options, updateData) -> updateData {data: [1, 2, 3]}
      delegate = TableDelegate {fetchData}
      expect(delegate.hasNoData()).toBe false

    it 'is true when the delegate has no data', ->
      fetchData = (options, updateData) -> updateData {data: []}
      delegate = TableDelegate {fetchData}
      expect(delegate.hasNoData()).toBe true

  describe '#sortData', ->
    it 'changes currentPage to 1', ->
      currentPage = 2
      pageSize = 1
      headers = [
        TableHeader {sortField: ''}
      ]
      fetchData = (options, updateData) -> updateData {data: [1, 2, 3]}
      delegate = TableDelegate {headers, fetchData, currentPage, pageSize}
      expect(delegate.isFirstPage()).toBe false
      delegate.sortData headers[0]
      expect(delegate.isFirstPage()).toBe true

    it 'sets currentSortHeader and calls reload', ->
      headers = [
        TableHeader {sortField: ''}
      ]
      numCalled = 0
      fetchData = (options, updateData) ->
        numCalled++
        {sortHeader} = options
        expect(sortHeader).toEqual expectedSortHeader
      expectedSortHeader = undefined
      delegate = TableDelegate {headers, fetchData}
      expectedSortHeader = headers[0]
      delegate.sortData expectedSortHeader
      expect(numCalled).toBe 2

  describe '#setVisibleColumns', ->
    context "given column 2 having initial visibility of false", ->
      it "changes the visibility of column 2 to true", ->
        called = false
        headers = [
          TableHeader {name: 'First', visible: true}
          TableHeader {name: 'Second', visible: false}
        ]
        fetchData = (options, updateData) ->
          called = true
        delegate = TableDelegate {fetchData, headers}
        delegate.setVisibleColumns([true, true])
        expect(delegate.headers[1].visible).toBe true

    it 'throws an error if array length does not match number of columns', ->
      called = false
      headers = [
        TableHeader {name: 'First', visible: true}
        TableHeader {name: 'Second', visible: false}
      ]
      fetchData = (options, updateData) ->
        called = true
      delegate = TableDelegate {fetchData, headers}
      expect(->
        delegate.setVisibleColumns([true])
      ).toThrow()
