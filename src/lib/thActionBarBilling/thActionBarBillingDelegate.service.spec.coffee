context = describe

describe 'ThemisComponents: Service: ActionBarBillingDelegate', ->
  ActionBarBillingDelegate = selectables = delegate = ViewModel = q = scope = null

  beforeEach angular.mock.module 'ThemisComponents'

  fixtures = {}
  fixtures.validDelegate = ->
    new ActionBarBillingDelegate
      onApply: ({trackedCollection, selectedAction}, reset) -> return
      availableActions: [{name: "one", value: 1}]
      retrieveIds: (vm) -> return
      collectionReferences: ["parent"]
  fixtures.data = ->
    data = {
      collection: [
        {id: 1, name: "a"}, {id: 2, name: "b"}, {id: 3, name: "c"},
        {id: 4, name: "d"}, {id: 5, name: "e"}, {id: 6, name: "f"}
      ]
      meta: totalItems: 6
    }
    return JSON.parse(JSON.stringify(data))
  fixtures.nestedData = ->
    data = {
      collection: [
        {id: 1, children: {collection: [{id: 10}, {id: 100}], meta: totalItems: 2}}
        {id: 2, children: {collection: [{id: 20}, {id: 200}], meta: totalItems: 2}}
        {id: 3, children: {collection: [{id: 30}, {id: 300}], meta: totalItems: 2}}
        {id: 4, children: {collection: [{id: 40}, {id: 400}], meta: totalItems: 2}}
      ],
      meta: totalItems: 4
    }
    return JSON.parse(JSON.stringify(data))

  beforeEach inject (_ActionBarBillingDelegate_, _ViewModel_, $q, $rootScope) ->
    ActionBarBillingDelegate = _ActionBarBillingDelegate_
    ViewModel = _ViewModel_
    q = $q
    scope = $rootScope

  describe "#constuctor", ->
    it "throws error without 'onApply'", ->
      delegate = ->
        new ActionBarBillingDelegate
          retrieveIds: -> return
          collectionReferences: ["parent"]

      expect(-> delegate()).toThrow()

    it "throws error without 'retrieveIds'", ->
      delegate = ->
        new ActionBarBillingDelegate
          onApply: -> return
          collectionReferences: ["parent"]

      expect(-> delegate()).toThrow()

    it "throws error without 'collectionReferences'", ->
      delegate = ->
        new ActionBarBillingDelegate
          onApply: -> return
          retrieveIds: -> return

      expect(-> delegate()).toThrow()

    it "exists", ->
      delegate = fixtures.validDelegate()
      expect(delegate?).toBe true

    it "exposes a 'results' object", ->
      delegate = fixtures.validDelegate()
      expect(delegate.results?).toBe true

    it "exposes utility functions", ->
      delegate = fixtures.validDelegate()
      expect(delegate.makeSelectable?).toBe true
      expect(delegate.evaluateOnApplyFunction?).toBe true
      expect(delegate.triggerReset?).toBe true


  describe "#makeSelectable", ->
    beforeEach ->
      delegate = fixtures.validDelegate()
      selectables = delegate.makeSelectable(fixtures.data())

    it "returns a SelectableCollection", ->
      # 2 properties that come from Selectable Collections
      expect(selectables.allIdentifiers).toEqual {}
      expect(selectables.loadingIds).toEqual no

    it "returns collection of view models", ->
      viewModelCount = selectables.filter (vm) -> vm instanceof ViewModel
      expect(viewModelCount.length).toBe 6

    it "sets up a 'root' view model", ->
      expect(delegate.results.actionBarModel.model.id).toBe "root"

  describe "#evaluateOnApplyFunction", ->
    called = false
    trackedData = resetFunc = action = null

    beforeEach ->
      delegate = new ActionBarBillingDelegate
        onApply: ({trackedCollection, selectedAction}, reset) ->
          called = true
          trackedData = trackedCollection
          resetFunc = reset
          action = selectedAction
        retrieveIds: (vm) -> return
        collectionReferences: ["parent"]

      selectables = delegate.makeSelectable(fixtures.data())

    it "evaluates the 'onApply' function passed in", ->
      delegate.evaluateOnApplyFunction()
      expect(called).toBe true

    it "passes the tracked collection as an argument", ->
      delegate.evaluateOnApplyFunction()
      expect(trackedData).toEqual []

    it "passes a reset function as an argument", ->
      delegate.evaluateOnApplyFunction()
      expect(typeof resetFunc is "function")

    context "with selected values", ->
      it "the selected values are returned", ->
        selectables[0].view.selected = true
        delegate.evaluateOnApplyFunction()
        expect(trackedData).toEqual [{id: 1, selected: true}]

      context "when reset is triggered", ->
        beforeEach ->
          selectables[0].view.selected = true
          delegate.results.selectedAction = {name: "one", value: 1}
          delegate.evaluateOnApplyFunction()
          resetFunc()

        it "resets tracked collection", ->
          expect(delegate.results.selectedItemCount).toBe 0

        it "resets the selected action", ->
          expect(delegate.results.selectedAction).toBe null

        it "resets the 'allSelected' flag", ->
          expect(delegate.results.allSelected).toBe false

        it "all tracked items are unselected", ->
          delegate.results.actionBarModel.model.parent.forEach (vm) ->
            expect(vm.view.selected).toBe false

    context "with selected action", ->
      it "the selected action is returned", ->
        delegate.results.selectedAction = {name: "one", value: 1}
        delegate.evaluateOnApplyFunction()
        expect(action).toBe 1

  context "with nested collection", ->
    describe "#evaluateOnApplyFunction", ->
      trackedData = resetFunc = null

      beforeEach ->
        delegate = new ActionBarBillingDelegate
          onApply: ({trackedCollection, selectedAction}, reset) ->
            trackedData = trackedCollection
            resetFunc = reset
          availableActions: [{name: "one", value: 1}]
          retrieveIds: (vm) ->
            id = vm.model.id; mockReturn = {}
            if id is "root"
              mockReturn = {1: [10, 100], 2: [20, 200], 3: [30, 300], 4: [40, 400]}
            else
              mockReturn = {id: [(id * 10), (id * 100)]}
            return q.when mockReturn
          collectionReferences: ["parent", "children"]

        firstPage = fixtures.nestedData()
       # Mock first page.
        offSet = firstPage.collection.slice(0, 2)

        firstPage.collection = offSet
        selectables = delegate.makeSelectable(firstPage)

      context "with selected data over several pages", ->
        it "returns all ids as selected", ->
          # trigger all incoming data as selected.
          delegate.results.actionBarModel.view.selected = yes
          scope.$apply()

          # Mock page change.
          nextPage = fixtures.nestedData()
          offset = nextPage.collection.slice(2, 4)
          nextPage.collection = offset
          selectables = delegate.makeSelectable(nextPage)
          scope.$apply()

          delegate.evaluateOnApplyFunction()
          trackedData.forEach (parent) ->
            expect(parent.selected).toBe true

            parent.children.forEach (child) ->
              expect(child.selected).toBe true

      context "with selected parent", ->
        it "the parent and its children are returned selected", ->
          selectables[0].view.selected = true
          scope.$apply()

          delegate.evaluateOnApplyFunction()
          expect(trackedData[0].children[0].selected).toBe true
          expect(trackedData[0].selected).toBe true

        context "when reset is triggered", ->
          it "reset all parents and children view models", ->
            selectables[1].view.selected = true
            scope.$apply()

            delegate.evaluateOnApplyFunction()
            expect(trackedData[0].selected).toBe true
            trackedData[0].children.forEach (child) ->
              expect(child.selected).toBe true

            resetFunc()
            selectables.collectionValues().forEach (parent) ->
              expect(parent.selected).toBe false

              parent.children.forEach (child) ->
                expect(child.selected).toBe false

          context "with several pages selected", ->
            it "reset all parents and child view models", ->
            # trigger all incoming data as selected.
              delegate.results.actionBarModel.view.selected = yes
              scope.$apply()

              # Mock page change.
              nextPage = fixtures.nestedData()
              offset = nextPage.collection.slice(2, 4)
              nextPage.collection = offset
              selectables = delegate.makeSelectable(nextPage)
              scope.$apply()

              delegate.evaluateOnApplyFunction()
              resetFunc()

              selectables.collectionValues().forEach (parent) ->
                expect(parent.selected).toBe false

                parent.children?.forEach (child) ->
                  expect(child.selected).toBe false
