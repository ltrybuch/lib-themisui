context = describe
describe 'ThemisComponents: Service: thTableHeader', ->
  TableHeader = null

  beforeEach ->
    module 'ThemisComponents'

    inject (_TableHeader_) ->
      TableHeader = _TableHeader_

  it 'should exist', ->
    expect(TableHeader?).toBe true

  describe '#constructor', ->
    name = 'A name'
    sortField = 'aField'

    it 'should throw if incorrect align is provided', ->
      align = 'wrong'
      expect(-> TableHeader {align}).toThrow()

    it 'should throw if sortActive and no sortField provided', ->
      sortDirection = 'ascending'
      sortActive = true
      expect(-> TableHeader {sortActive, sortDirection}).toThrow()

    it 'should throw if sortActive and no sortDirection provided', ->
      sortActive = true
      expect(-> TableHeader {sortField, sortActive}).toThrow()

    it 'should throw if incorrect sortDirection is provided', ->
      sortDirection = 'wrong'
      sortActive = true
      expect(-> TableHeader {sortActive, sortDirection, sortField}).toThrow()

    it 'should expose name and sortField', ->
      header = TableHeader {name, sortField}
      expect(header.name).toEqual name
      expect(header.sortField).toEqual sortField

  describe '#cssClasses', ->
    sortField = 'aField'

    context 'sorting disabled', ->
      it 'should have proper sort and align classes', ->
        header = TableHeader()
        classes = header.cssClasses()
        expect(classes.includes(klass)).toBe true for klass in [
          'th-table-sort-none'
          'th-table-align-left'
        ]

    context 'sorting enabled, inactive', ->
      it 'should have proper sort and align classes', ->
        header = TableHeader {sortField}
        classes = header.cssClasses()
        expect(classes.includes(klass)).toBe true for klass in [
          'th-table-sortable'
          'th-table-sort-none'
          'th-table-align-left'
        ]

    context 'sorting enabled, active', ->
      sortActive = true
      sortDirection = 'ascending'

      it 'should have proper sort and align classes', ->
        header = TableHeader {sortField, sortActive, sortDirection}
        classes = header.cssClasses()
        expect(classes.includes(klass)).toBe true for klass in [
          'th-table-sortable'
          'th-table-sort-ascending'
          'th-table-align-left'
        ]

  describe '#isSortActive', ->
    it 'returns sortActive', ->
      sortField = 'aField'
      sortActive = true
      sortDirection = 'ascending'
      header = TableHeader {sortField, sortActive, sortDirection}
      expect(header.isSortActive()).toBe true

  describe '#getSortDirection', ->
    it 'returns sortDirection', ->
      sortField = 'aField'
      sortActive = true
      sortDirection = 'descending'
      header = TableHeader {sortField, sortActive, sortDirection}
      expect(header.getSortDirection()).toEqual sortDirection

  describe '#activateSort', ->
    it 'changes the value of sortActive and sortDirection', ->
      sortField = 'aField'
      header = TableHeader {sortField}
      header.activateSort()
      expect(header.isSortActive()).toBe true
      expect(header.getSortDirection()).toBe 'ascending'

  describe '#deactivateSort', ->
    it 'changes the value of sortActive and sortDirection', ->
      sortField = 'aField'
      sortActive = true
      sortDirection = 'ascending'
      header = TableHeader {sortField, sortActive, sortDirection}
      header.deactivateSort()
      expect(header.isSortActive()).toBe false
      expect(header.getSortDirection()).toBe undefined

  describe '#toggleSortDirection', ->
    it 'changes the value of sortDirection', ->
      sortField = 'aField'
      sortActive = true
      sortDirection = 'ascending'
      header = TableHeader {sortField, sortActive, sortDirection}
      header.toggleSortDirection()
      expect(header.getSortDirection()).toEqual 'descending'
      header.toggleSortDirection()
      expect(header.getSortDirection()).toEqual 'ascending'
