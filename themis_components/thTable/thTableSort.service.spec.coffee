context = describe
describe 'ThemisComponents: Service: thTableSort', ->
  TableSort = TableHeader = null

  beforeEach ->
    module 'ThemisComponents'

    inject (_TableSort_, _TableHeader_) ->
      TableSort = _TableSort_
      TableHeader = _TableHeader_

  it 'exists', ->
    expect(TableSort?).toBe true

  describe '#sort', ->
    context 'array of ints', ->
      array = [1, 5, 3, 4, 2]
      sortField = ''
      sortActive = true

      it 'sorts ascending', ->
        sortDirection = 'ascending'
        header = TableHeader {sortField, sortActive, sortDirection}
        {sort} = TableSort
        sortedArray = sort array, header
        expect(sortedArray).toEqual [1, 2, 3, 4, 5]

      it 'sorts descending', ->
        sortDirection = 'descending'
        header = TableHeader {sortField, sortActive, sortDirection}
        {sort} = TableSort
        sortedArray = sort array, header
        expect(sortedArray).toEqual [5, 4, 3, 2, 1]

    context 'array of objects w/ deeply nested int fields', ->
      it 'sorts', ->
        convertToNestedObject = (val) -> {deeply: {nested: {field: val}}}
        array = [1, 5, 3, 4, 2].map convertToNestedObject
        sortField = 'deeply.nested.field'
        sortActive = true
        sortDirection = 'ascending'
        header = TableHeader {sortField, sortActive, sortDirection}
        {sort} = TableSort
        sortedArray = sort array, header
        expect(sortedArray).toEqual [1, 2, 3, 4, 5].map convertToNestedObject

    context 'array of objects w/ boolean fields', ->
      it 'sorts', ->
        convertToNestedObject = (val) -> {val}
        array = [true, false, true].map convertToNestedObject
        sortField = 'val'
        sortActive = true
        sortDirection = 'ascending'
        header = TableHeader {sortField, sortActive, sortDirection}
        {sort} = TableSort
        sortedArray = sort array, header
        expect(sortedArray).toEqual [false, true, true].map convertToNestedObject

    context 'array of objects w/ string fields', ->
      it 'sorts', ->
        convertToNestedObject = (val) -> {val}
        array = ["a", "c", "b"].map convertToNestedObject
        sortField = 'val'
        sortActive = true
        sortDirection = 'ascending'
        header = TableHeader {sortField, sortActive, sortDirection}
        {sort} = TableSort
        sortedArray = sort array, header
        expect(sortedArray).toEqual ["a", "b", "c"].map convertToNestedObject
