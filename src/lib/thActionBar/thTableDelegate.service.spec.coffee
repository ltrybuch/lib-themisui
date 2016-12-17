context = describe

describe "ThemisComponents: Service: ActionBarDelegate", ->
  ActionBarDelegate = selectables = delegate = ViewModel = q = scope = null

  beforeEach angular.mock.module "ThemisComponents"

  fixtures = {}

  fixtures.validDelegate = ->
    new ActionBarDelegate
      onApply: ({ids, selectedAction}, reset) -> return
      availableActions: [{name: "one", value: 1}]

  fixtures.data = ->
    data = [
      {id: 1, name: "a"}, {id: 2, name: "b"}, {id: 3, name: "c"},
      {id: 4, name: "d"}, {id: 5, name: "e"}, {id: 6, name: "f"}
    ]
    return JSON.parse JSON.stringify data

  beforeEach inject (_ActionBarDelegate_, _ViewModel_, $q, $rootScope) ->
    ActionBarDelegate = _ActionBarDelegate_
    ViewModel = _ViewModel_
    q = $q
    scope = $rootScope

  describe "#constuctor", ->
    it "exists", ->
      delegate = fixtures.validDelegate()
      expect(delegate?).toBe true

    it "exposes a 'results' object", ->
      delegate = fixtures.validDelegate()
      expect(delegate.results?).toBe true

    it "exposes utility functions", ->
      delegate = fixtures.validDelegate()
      expect(delegate.makeSelectable?).toBe true
      expect(delegate.triggerApply?).toBe true


  describe "#makeSelectable", ->
    beforeEach ->
      delegate = fixtures.validDelegate()
      selectables = delegate.makeSelectable fixtures.data()

    it "returns collection of view models", ->
      viewModelCount = selectables.filter (vm) -> vm instanceof ViewModel
      expect(viewModelCount.length).toBe 6

    it "resets internal values when called twice", ->
      delegate.results.allSelected = yes
      delegate.results.selectedAction = {name: "one", value: 1}

      secondCollection = delegate.makeSelectable fixtures.data()
      expect(delegate.results.allSelected).toBe no
      expect(delegate.results.selectedAction).toBe null

  describe "#triggerApply", ->
    trackedData = resetFunc = action = called = null

    beforeEach ->
      delegate = new ActionBarDelegate
        onApply: ({ids, selectedAction}, reset) ->
          called = true
          trackedData = ids
          resetFunc = reset
          action = selectedAction
        availableActions: [{name: "one", value: 1}]

      selectables = delegate.makeSelectable fixtures.data()
      delegate.results.selectedAction = {name: "one", value: 1}

    it "evaluates the 'onApply' function passed in", ->
      delegate.triggerApply()
      expect(called).toBe true

    it "passes the tracked collection as an argument", ->
      delegate.triggerApply()
      expect(trackedData).toEqual []

    it "passes a reset function as an argument", ->
      delegate.triggerApply()
      expect(typeof resetFunc is "function").toBe true

    context "with selected values", ->
      it "the selected values are returned", ->
        selectables[0].view.selected = true
        delegate.triggerApply()
        expect(trackedData).toEqual [1]

      context "when reset is triggered", ->
        beforeEach ->
          selectables[0].view.selected = true
          delegate.results.selectedAction = {name: "one", value: 1}
          delegate.triggerApply()
          resetFunc()

        it "resets the selected action", ->
          expect(delegate.results.selectedAction).toBe null

        it "resets the 'allSelected' flag", ->
          expect(delegate.results.allSelected).toBe false

        it "all tracked items are unselected", ->
          selectables.forEach (vm) ->
            expect(vm.view.selected).toBe false

    context "with selected action", ->
      it "the selected action is returned", ->
        delegate.triggerApply()
        expect(action).toBe 1

  describe "#isDisabled", ->
    beforeEach ->
      delegate = fixtures.validDelegate()

    it "when in processing state", ->
      delegate.results.processing = yes
      expect(delegate.isDisabled()).toEqual yes

    it "when no action is selected", ->
      expect(delegate.isDisabled()).toEqual yes

    it "when an action is selected", ->
      delegate.results.selectedAction = {name: "one", value: 1}
      expect(delegate.isDisabled()).toEqual no

    it "when no action is selected but also no actions available", ->
      delegate = new ActionBarDelegate
        onApply: ({ids, selectedAction}, reset) -> reset

      expect(delegate.isDisabled()).toEqual no
