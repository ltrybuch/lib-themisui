context = describe
describe 'ThemisComponents: Service: thTableHeader', ->
  TableHeader = null

  beforeEach ->
    angular.mock.module 'ThemisComponents'

    inject (_TableHeader_) ->
      TableHeader = _TableHeader_

  it 'exists', ->
    expect(TableHeader?).toBe true

  describe '#constructor', ->
    name = 'A name'
    sortField = 'aField'

    it 'throws if incorrect align is provided', ->
      align = 'wrong'
      expect(-> TableHeader {align}).toThrow()

    it 'throws if sortActive and no sortField provided', ->
      sortActive = true
      expect(-> TableHeader {sortActive}).toThrow()

    it 'throws if incorrect sortDirection is provided', ->
      sortDirection = 'wrong'
      sortActive = true
      expect(-> TableHeader {sortActive, sortDirection, sortField}).toThrow()

    it 'exposes name and sortField', ->
      header = TableHeader {name, sortField}
      expect(header.name).toEqual name
      expect(header.sortField).toEqual sortField

    it 'sets sortDirection to ascending if undefined and sortActive is true', ->
      sortActive = true
      header = TableHeader {sortField, sortActive}
      expect(header.getSortDirection()).toEqual 'ascending'

  describe '#cssClasses', ->
    sortField = 'aField'

    context 'sorting disabled', ->
      it 'has proper sort and align classes', ->
        header = TableHeader()
        classes = header.cssClasses()
        expect(classes.includes(klass)).toBe true for klass in [
          'th-table-sort-none'
          'th-table-align-left'
        ]

    context 'sorting enabled, inactive', ->
      it 'has proper sort and align classes', ->
        header = TableHeader {sortField}
        classes = header.cssClasses()
        expect(classes.includes(klass)).toBe true for klass in [
          'th-table-sortable'
          'th-table-sort-none'
          'th-table-align-left'
        ]

    context 'sorting enabled, active', ->
      sortActive = true

      it 'has proper sort and align classes', ->
        header = TableHeader {sortField, sortActive}
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
      header = TableHeader {sortField, sortActive}
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
      expect(header.getSortDirection()).toEqual 'ascending'

  describe '#deactivateSort', ->
    it 'changes the value of sortActive and sortDirection', ->
      sortField = 'aField'
      sortActive = true
      header = TableHeader {sortField, sortActive}
      header.deactivateSort()
      expect(header.isSortActive()).toBe false

  describe '#toggleSortDirection', ->
    it 'changes the value of sortDirection', ->
      sortField = 'aField'
      sortActive = true
      header = TableHeader {sortField, sortActive}
      header.toggleSortDirection()
      expect(header.getSortDirection()).toEqual 'descending'
      header.toggleSortDirection()
      expect(header.getSortDirection()).toEqual 'ascending'
