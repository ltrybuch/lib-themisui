EventEmitter = require 'events'
context = describe

describe 'ThemisComponents: Service: SelectableCollection', ->
  collectionInstance = ViewModel = SelectableCollection = fixtures = scope = q = null

  beforeEach angular.mock.module 'ThemisComponents'

  beforeEach inject (_SelectableCollection_, _ViewModel_, $rootScope, _$q_) ->
    SelectableCollection = _SelectableCollection_
    ViewModel = _ViewModel_
    scope = $rootScope.$new()
    q = _$q_

  fixtures =
    retrieveIdsFunc: -> return new Promise (res) -> resolve [1, 2, 3, 4, 5, 6]

    retrieveIdsNestedFunc: (vm) ->
      id = vm.model.id; mockReturn = {}
      mockReturn[id] = [id * 10]
      return q.when mockReturn

    data:
      [
        {id: 1, name: "a"}, {id: 2, name: "b"}, {id: 3, name: "c"},
        {id: 4, name: "d"}, {id: 5, name: "e"}, {id: 6, name: "f"}
      ]

    nestedData: ->
      data = [{
        id: 1
        name: "a"
        children:
          collection: [{id: 10, name: "a1"}]
          meta: totalItemCount: 1
      },
      {
        id: 2
        name: "b"
        children:
          collection: [{id: 20, name: "b1"}, {id: 22, name: "b2"}]
          meta: totalItemCount: 2
      }]
      return JSON.parse(JSON.stringify(data))

  context "with a single level collection", ->
    beforeEach ->
      collectionInstance = new SelectableCollection
        array: fixtures.data
        totalItems: fixtures.data.length
        retrieveIds: fixtures.retrieveIdsFunc

    it 'exists', -> expect(SelectableCollection?).toBe true

    describe "#constructor", ->
      it "sets up needed values", ->
        expect(collectionInstance.allIdentifiers).toEqual {}
        expect(collectionInstance.loadingIds).toEqual no

      it "converts input data and returns the same number of view models", ->
        expect(collectionInstance.length).toBe 6
        collectionInstance.forEach (vm) ->
          expect(vm instanceof ViewModel)

      it "wrapped input data in a view model", ->
        collectionInstance.forEach (vm, i) ->
          expect(vm.model).toEqual fixtures.data[i]
          expect(vm instanceof ViewModel).toBe true

      it "and adds 'selected' property to view state equal to false", ->
        collectionInstance.forEach (vm) ->
          expect(vm.view.selected).toBe false

      it "attached listeners to each view model", ->
        viewModel = collectionInstance[0]
        expect(viewModel instanceof require("events").EventEmitter).toBe true

    describe "#collectionValues", ->
      it "returns a formatted collection of all viewModels", ->
        formattedFixtureData = fixtures.data.map (each) -> {id: each.id, selected: false}
        selectedValues = collectionInstance.collectionValues()
        expect(selectedValues).toEqual formattedFixtureData

    describe "#addToSelectableCollection", ->
      it "adds argument data to our selectableCollection", ->
        newData = [{id: 7, name: "g"}, {id: 8, name: "h"}]
        collectionInstance.addToSelectableCollection(newData)

        newDataAdded = collectionInstance.collectionValues().filter (vm) ->
          vm.id is newData[0].id or vm.id is newData[1].id

        expect(collectionInstance.length).toEqual (fixtures.data.length + newData.length)
        expect(newDataAdded.length).toEqual newData.length

    describe "when a viewModel's selected state is toggled", ->

      it "updates selectableCollection return value accordingly", ->
        viewModel = collectionInstance[0]

        viewModel.view.selected = true
        internalValue = collectionInstance.collectionValues()[0]
        expect(internalValue.selected).toBe true

        viewModel.view.selected = false
        internalValue = collectionInstance.collectionValues()[0]
        expect(internalValue.selected).toBe false

    describe "when all viewModel's selected state are toggled", ->
      it "updates selectableCollection return value accordingly", ->
        calculateSelectedCount = ->
          return collectionInstance.reduce (count, item) ->
            if item.view.selected then ++count else count
          , 0

        collectionInstance.forEach (vm) -> vm.view.selected = true
        selectedCount = calculateSelectedCount()

        expect(selectedCount).toEqual fixtures.data.length

        collectionInstance.forEach (vm) -> vm.view.selected = false
        selectedCount = calculateSelectedCount()

        expect(selectedCount).toEqual 0

  context "with nested collections", ->
    beforeEach ->
      collectionInstance = new SelectableCollection
        array: fixtures.nestedData()
        totalItems: fixtures.nestedData().length
        retrieveIds: fixtures.retrieveIdsNestedFunc

    it 'exists', -> expect(SelectableCollection?).toBe true

    describe "#constructor", ->
      it "sets up needed values", ->
        expect(collectionInstance.allIdentifiers).toEqual {}
        expect(collectionInstance.loadingIds).toEqual no

      it "converts input data and returns the same number of view models", ->
        expect(collectionInstance.length).toBe 2

      it "wrapped input data in a view model", ->
        collectionInstance.forEach (vm, i) ->
          expect(vm instanceof ViewModel).toBe true

      it "converts nested collection to new SelectableCollections", ->
        collectionInstance.forEach (vm) ->
          nestedCollection = vm.model.children
          expect(nestedCollection.hasOwnProperty("parent")).toBe true
          expect(nestedCollection.hasOwnProperty("loadingIds")).toBe true
          expect(nestedCollection.hasOwnProperty("allIdentifiers")).toBe true

          vm.model.children.forEach (nestedVm) ->
            expect(nestedVm instanceof ViewModel).toBe true

      it "nested collections are given a parent reference on creation", ->
        collectionInstance.forEach (vm) ->
          nestedCollection = vm.model.children
          expect(nestedCollection.parent.model.id).toEqual vm.model.id

    describe "when a viewModel's selected state is toggled", ->
      it "updates selectableCollection return value accordingly", ->
        viewModel = collectionInstance[0]

        viewModel.view.selected = true
        internalValue = collectionInstance.collectionValues()[0]
        expect(internalValue.selected).toBe true

        viewModel.view.selected = false
        internalValue = collectionInstance.collectionValues()[0]
        expect(internalValue.selected).toBe false

      it "toggles all children view models", ->
        viewModel = collectionInstance[0]
        viewModel.view.selected = true
        scope.$apply()

        child = viewModel.model.children[0]
        expect(child.view.selected).toBe true

        viewModel.view.selected = false
        scope.$apply()

        expect(child.view.selected).toBe false

      it "fetches ids for all viewmodels", (done) ->
        spyOn(fixtures, "retrieveIdsNestedFunc")
        collectionInstance.forEach (vm) -> vm.view.selected = true
        done()
        expect(fixtures.retrieveIdsNestedFunc).toHaveBeenCalled()

    describe "#collectionValues", ->
      it "returns a formatted collection of all viewModels", ->
        expectedValues = [
          {id: 1, selected: false, children: [id: 10, selected: false]},
          {id: 2, selected: false, children: [{id: 20, selected: false}, id: 22, selected: false]}
        ]
        actualValues = collectionInstance.collectionValues()

        expect(angular.equals(actualValues, expectedValues)).toEqual true

      context "when parent selected value exists", ->
        beforeEach ->
          collectionInstance[0].view.selected = true
          scope.$apply()

        it "returns the correct selected values", ->
          selectedValue = collectionInstance.collectionValues()[0]
          expect(selectedValue.selected).toBe true

        it "the children are also returned selected", ->
          selectedValuesChild = collectionInstance.collectionValues()[0].children[0]
          expect(selectedValuesChild.selected).toBe true

      context "the child is selected", ->
        context "when only one child exists", ->
          beforeEach ->
            child = collectionInstance[0].model.children[0]
            child.view.selected = true
            scope.$apply()

          it "the parent is returned selected", ->
            parentValue = collectionInstance.collectionValues()[0]
            expect(parentValue.selected).toBe true

          it "the child is returned selected", ->
            child = collectionInstance.collectionValues()[0].children[0]
            expect(child.selected).toBe true

        context "when multiple children exists", ->
          beforeEach ->
            childWithSibling = collectionInstance[1].model.children[0]
            childWithSibling.view.selected = true

          it "the child is returned selected", ->
            child = collectionInstance.collectionValues()[1].children[0]
            expect(child.selected).toBe true

          it "the parent is returned unselected", ->
            parentValue = collectionInstance.collectionValues()[1]
            expect(parentValue.selected).toBe false

      context "when all children are selected", ->
        it "the parent is returned selected", ->
          childWithSibling = collectionInstance[1].model.children[0]
          childWithSibling.view.selected = true
          sibling = collectionInstance[1].model.children[1]
          sibling.view.selected = true

          parentValue = collectionInstance.collectionValues()[1]
          expect(parentValue.selected).toBe true

      context "the child is selected and then unselected", ->
        context "when only one child exists", ->

          it "the parent is returned unselected", ->
            child = collectionInstance[0].model.children[0]

            child.view.selected = true
            scope.$apply()
            parentValue = collectionInstance.collectionValues()[0]
            expect(parentValue.selected).toBe true

            child.view.selected = false
            scope.$apply()
            parentValue = collectionInstance.collectionValues()[0]
            expect(parentValue.selected).toBe false

    describe "#addToSelectableCollection", ->
      context "adding to child collection", ->
        it "adds argument data to our selectableCollection", ->
          newData = [{id: 7, name: "g"}, {id: 8, name: "h"}]
          childCollection = collectionInstance[0].model.children
          originalLength = childCollection.length
          childCollection.addToSelectableCollection(newData)
          newDataAdded = childCollection.collectionValues().filter (vm) ->
            vm.id is newData[0].id or vm.id is newData[1].id

          expect(childCollection.length).toEqual (originalLength + newData.length)
          expect(newDataAdded.length).toEqual newData.length

        context "when the parent is selected", ->
          it "all incoming data's selected values are true", ->
            collectionInstance[0].view.selected = true
            scope.$apply()

            newData = [{id: 7, name: "g"}, {id: 8, name: "h"}]
            childCollection = collectionInstance[0].model.children
            originalLength = childCollection.length

            childCollection.addToSelectableCollection(newData)

            selectedChildren = childCollection.collectionValues().filter (vm) ->
              return vm.selected

            expect(selectedChildren.length).toEqual (originalLength + newData.length)
