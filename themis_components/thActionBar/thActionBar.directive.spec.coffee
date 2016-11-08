{compileDirective} = require "spec_helpers"

context = describe

normalizeText = (text) -> text.trim().replace /\s+/g, ' '

describe 'ThemisComponents: Directive: thActionBar', ->
  scope = element = delegate = fixtures = controller = ActionBarDelegate = q = null

  fixtures =
    resetFunction: null
    onApplyCalled: false
    data: ->
      data =
        collection: [
          {id: 1, children: {collection: [{id: 1}], meta: totalItems: 1}}
          {id: 2, children: {collection: [{id: 2}], meta: totalItems: 1}}
        ],
        meta: totalItems: 2

      return JSON.parse(JSON.stringify(data))

    delegate: (options = {}) ->
      {addActions = true} = options
      actionBarOptions = {}
      actionBarOptions.onApply = ({}, reset) ->
        fixtures.onApplyCalled = true
        fixtures.resetFunction = reset
      actionBarOptions.retrieveIds = (vm) ->
        id = vm.model.id; mockReturn = {}
        if id is "root"
          mockReturn = {1: [1], 2: [2]}
        else
          mockReturn = {id: [id]}
        return q.when mockReturn
      actionBarOptions.collectionReferences = ["parents", "children"]
      if addActions
        actionBarOptions.availableActions = [{name: "a", value: 1}]
      return new ActionBarDelegate actionBarOptions
    setUp: (template, options) ->
      scopeAdditions = delegate: fixtures.delegate(options)
      {element, scope} = compileDirective(template, scopeAdditions)
      delegate = scope.$$childHead.actionBar.delegate
      delegate.makeSelectable(fixtures.data())
      scope.$apply()

  beforeEach angular.mock.module 'ThemisComponents'
  beforeEach inject (_ActionBarDelegate_, $timeout, $q) ->
    ActionBarDelegate = _ActionBarDelegate_
    q = $q

  context "when the select all checkbox is selected", ->
    beforeEach ->
      template = """
        <th-action-bar delegate="delegate">
          <span class="find-me"></span>
        </th-action-bar>
      """
      fixtures.setUp(template)
      controller = scope.$$childHead.actionBar
      delegate.results.allSelected = true
      controller.toggleAll()
      scope.$apply()

    it "transclude any included content", ->
      expect(element.find(".find-me").length).toBe 1

    it "shows the action menu", ->
      expect(element.find("select").length).toBe 1

    it "shows selected item text", ->
      expect(element.find(".action-text").length).toBe 1

    it "show select component with option(s) from delegate", ->
      expect(element.find("option[value='1']").length).toBe 1

    it "uses default 'item' name in text", ->
      expectedText = normalizeText(element.find(".action-text").text())
      expect(expectedText).toBe "2 items selected."

    it "displays an apply button", ->
      expect(element.find(".th-button").length).toBe 1

      expectedText = normalizeText(element.find("button").text())
      expect(expectedText).toBe "Apply"

    context "and then unselected", ->
      beforeEach ->
        delegate.results.allSelected = false
        controller.toggleAll()
        scope.$apply()

      it "hides the action menu", ->
        expect(element.find("select").length).toBe 0

      it "hides selected item text", ->
        expect(element.find(".action-text").length).toBe 0

      it "hides select component with option(s) from delegate", ->
        expect(element.find("option[value='1']").length).toBe 0

      it "hides an apply button", ->
        expect(element.find(".th-button").length).toBe 0

  context "with an item-name attr and button-name attr", ->
    beforeEach ->
      template = """
        <th-action-bar
          delegate="delegate"
          item-name="recent contact"
          button-name="update"
          >
          <span class="find-me"></span>
        </th-action-bar>
      """
      fixtures.setUp(template)

      controller = scope.$$childHead.actionBar
      delegate.results.allSelected = true
      controller.toggleAll()
      scope.$apply()

    it "displays a selected count with custom item name", ->
      expectedText = normalizeText(element.find(".action-text").text())
      expect(expectedText).toBe "2 recent contacts selected."

    it "only pluralizes the last word in multiworded item names", ->
      expectedText = normalizeText(element.find(".action-text").text())
      expect(expectedText).toBe "2 recent contacts selected."

    it "displays a button with custom name", ->
      expectedText = normalizeText(element.find("button").text())
      expect(expectedText).toBe "update"

  context "when the apply button is clicked", ->
    beforeEach ->
      template = """
        <th-action-bar delegate="delegate">
          <span class="find-me"></span>
        </th-action-bar>
      """
      fixtures.setUp(template)
      controller = scope.$$childHead.actionBar
      delegate.results.allSelected = true
      controller.toggleAll()
      scope.$apply()

    it "trigger the delegate's onApply function", ->
      expect(fixtures.onApplyCalled).toBe false
      element.find(".th-button").triggerHandler "click"
      expect(fixtures.onApplyCalled).toBe true

    it "reset the action bar when reset triggered", ->
      element.find(".th-button").triggerHandler "click"
      fixtures.resetFunction()
      scope.$apply()

      expect(element.find("select").length).toBe 0
      expect(element.find(".action-text").length).toBe 0
      expect(element.find("option[value='1']").length).toBe 0
      expect(element.find(".th-button").length).toBe 0


  context "when 'availableActions' are not provided", ->
    beforeEach ->
      template = """
        <th-action-bar delegate="delegate">
          <span class="find-me"></span>
        </th-action-bar>
      """
      fixtures.setUp(template, {addActions: no})

    it "does not include the dropdown select", ->
      delegate.results.allSelected = true
      controller.toggleAll()
      scope.$apply()

      expect(element.find("select").length).toBe 0
