context = describe

describe 'ThemisComponents: Service: ActionBarDelegate', ->
  ActionBarDelegate = selectable = delegate = null
  fixture = item = selectAllItems = isSelected = timeout = null

  beforeEach angular.mock.module 'ThemisComponents'
  pageSize = 3
  totalItemCount = 6
  onApply = -> return

  validDelegate = ->
    new ActionBarDelegate
      onApply: onApply
      availableActions: [{name: "one", value: 1}]
      pageSize: pageSize

  fixtureData = ->
    [
      {id: 1, name: "a"}, {id: 2, name: "b"}, {id: 3, name: "c"},
      {id: 4, name: "d"}, {id: 5, name: "e"}, {id: 6, name: "f"}
    ]

  beforeEach inject (_ActionBarDelegate_) -> ActionBarDelegate = _ActionBarDelegate_

  beforeEach ->
    fixture = fixtureData().slice 0, 3
    delegate = validDelegate()
    selectable = delegate.makeSelectable(
      {data: fixture, totalItems: totalItemCount, currentPage: 1}
    )

    selectAllItems = ->
      delegate.selectEntireCollection()
      selectedCount = delegate.results.selectedItemCount
      totalItemCount = delegate.results.totalItemCount
      selectedCount is totalItemCount

    isSelected = (object) ->
      item = delegate.results.selectedItems.find (o) -> angular.equals o, object
      return if item then yes else no

  it 'exists', -> expect(ActionBarDelegate?).toBe true

  describe '#constructor', ->
    it 'throws if no "onApply" function is passed', ->
      expect(-> ActionBarDelegate()).toThrow()

    it "throws if no select options are passed", ->
      expect(-> ActionBarDelegate({onApply: -> return})).toThrow()

  describe "#makeSelectable", ->
    it "returns a selectable array with length of the current page size", ->
      expect(selectable?).toBe true
      expect(selectable.length).toBe pageSize

    it "returns each item with a selected property", ->
      hasSeleectedProperty = selectable.reduce (_, o) -> o.view.selected?
      expect(hasSeleectedProperty).toBe true

    it "sets total item count", ->
      expect(delegate.results.totalItemCount).toEqual totalItemCount

    context "when resetSelection property is true", ->
      it "all items are deselected", ->
        delegate.selectPage()
        delegate.makeSelectable(
          {data: fixtureData(), totalItems: 3, currentPage: 1, resetSelection: true}
        )
        expect(delegate.results.selectedItemCount).toBe 0

  describe "#toggleSelected", ->
    context "when object is not selected", ->
      beforeEach ->
        item = selectable[0]
        delegate.toggleSelected(item)

      it "selects object", ->
        expect(item.view.selected).toBe true

      it "adds item to internal selected collection", ->
        expect(delegate.results.selectedItemCount).toBe 1

    context "when object is selected", ->
      beforeEach ->
        item = selectable[0]
        delegate.toggleSelected(item)
        delegate.toggleSelected(item)

      it "it deselects object", ->
        expect(item.view.selected).toBe false

      it "removes item from internal selected collection", ->
        expect(delegate.results.selectedItemCount).toBe 0

  describe "#clearEntireCollection", ->
    it "deselects entire selected collection", ->
      expect(selectAllItems()).toBe true
      delegate.clearEntireCollection()
      selectedCount = delegate.results.selectedItemCount
      expect(selectedCount).toEqual 0

  describe "#clearPage", ->
    context "when the current page is selected", ->
      it "deselects the current page", ->
        delegate.selectPage()
        expect(delegate.results.selectedItemCount).toEqual pageSize

        delegate.clearPage()
        expect(delegate.results.selectedItemCount).toEqual 0

    context "when selected items span more than current page", ->
      it "deselects the current page only", ->
        delegate.selectPage() # select current page
        pgTwoData = fixtureData().slice 3, 6
        delegate.makeSelectable(
          {data: pgTwoData, totalItems: 3, currentPage: 2, resetSelection: true}
        )
        delegate.selectPage() # select next page
        selectedCount = delegate.results.selectedItemCount
        totalItemCount = delegate.results.totalItemCount
        expect(selectedCount).toEqual totalItemCount

        delegate.clearPage() # deselect current page
        selectedCount = delegate.results.selectedItemCount
        totalItemCount = delegate.results.totalItemCount
        expect(selectedCount).toEqual totalItemCount - pageSize

  describe "#selectPage", ->
    context "when requesting entirety of items to be selected", ->
      it "add all items to the selected collection", ->
        expect(selectAllItems()).toBe true

    context "when requesting the current page to be selected", ->
      it "only the current page is selected", ->
        delegate.selectPage()
        selectedItems = delegate.results.selectedItemCount
        expect(selectable.length).toEqual selectedItems

  describe "#setSelectedAction", ->
    context "when argument is selected placeholder", ->
      it "selectedAction is == ''", ->
        selectedAction = delegate.setSelectedAction()
        expect(selectedAction).toBe ""

    context "when argument is valid", ->
      it "selectedAction is equal to argument.value", ->
        selectedAction =
          delegate.setSelectedAction(delegate.results.availableActions[0])
        expect(selectedAction).toBe 1
