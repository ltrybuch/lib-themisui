{
  compileDirective
} = require "spec_helpers"
context = describe
normalizeText = (text) -> text.trim().replace /\s+/g, ' '

describe 'ThemisComponents: Directive: thTableActionBar', ->
  scope = element = ActionBarDelegate = timeout = setUp = null

  validDelegate = (options) ->
    extended = angular.extend {
      onApply: -> return
      availableActions: [{name: "one", value: 1}]
      pageSize: 1
    }, options
    new ActionBarDelegate extended

  setUp = (options = {}) ->
    scopeAdditions = {delegate: validDelegate(options.delegateOptions)}
    extended = angular.extend {
      data: [{id: 1, name: "a"}], totalItems: 2, currentPage: 1
    }, options.dataOptions

    scopeAdditions.delegate.makeSelectable extended

    {scope, element} = compileDirective("""
      <th-table-action-bar delegate="delegate" #{options.templateOptions}>
        <span class="find-me"></span>
      </th-table-action-bar>""",
      scopeAdditions
    )

  beforeEach angular.mock.module 'ThemisComponents'
  beforeEach inject (_ActionBarDelegate_, $timeout) ->
    ActionBarDelegate = _ActionBarDelegate_
    timeout = $timeout

  it "transclude any included content", ->
    setUp()
    expect(element.find(".find-me").length).toBe 1

  context "when the select all checkbox is selected", ->
    beforeEach ->
      setUp()
      scope.$apply -> scope.delegate.selectPage()

    it "should show the action menu", ->
      expect(element.find(".action-menu").length).toBe 1

    it "should show select component with option(s) from delegate", ->
      expect(element.find("select").length).toBe 1
      expect(element.find("option[value='1']").length).toBe 1

    it "should display a selected count", ->
      normalized = normalizeText element.find(".selected-items-text").text()
      expect(normalized).toBe "1 item selected."

    it "should display a link to select entire collection", ->
      link = element.find(".action-text a").first()
      expect(normalizeText(link.text())).toBe "Select all 2 items"

    it "should display an apply button", ->
      expect(element.find("button").length).toBe 1
      expect(element.find("button ng-transclude").text().trim()).toBe "Apply"

  context "with an item name attr", ->
    beforeEach ->
      setUp({templateOptions: "item-name = tag"})
      scope.$apply -> scope.delegate.selectPage()

    it "should display a selected count with an item name", ->
      normalized = normalizeText element.find(".selected-items-text").text()
      expect(normalized).toBe "1 tag selected."

    it "should display a link to select entire collection with item name", ->
      link = element.find(".action-text a").first()
      expect(normalizeText(link.text())).toBe "Select all 2 tags"

  context "with a button name attr", ->
    beforeEach ->
      setUp({templateOptions: "button-name = generate"})
      scope.$apply -> scope.delegate.selectPage()

    it "should use 'button-name' value as the uhh button name", ->
      text = normalizeText element.find('.th-button ng-transclude span').text()
      expect(text).toBe "generate"

  context "when total item count is <= page size", ->
    it "should only include a limited action text without select all link", ->
      setUp({dataOptions: {totalItems: 1}})
      scope.$apply -> scope.delegate.selectPage()
      normalized = normalizeText element.find(".action-text").text()
      expect(normalized).toBe "(1 selected.) Clear selection"

  context "when clicking on 'clear selection link'", ->
    it "should hide the action bar", ->
      setUp()
      scope.$apply -> scope.delegate.selectPage()
      element.find(".action-text a").last().triggerHandler "click"
      expect(element.find(".action-text").length).toBe 0

  context "when clicking on the 'select all' link", ->
    beforeEach ->
      setUp()
      scope.$apply -> scope.delegate.selectPage()

    it "should update selected item count to include all items", ->
      normalized = normalizeText element.find(".selected-items-text").text()
      expect(normalized).toBe "1 item selected."

      element.find(".action-text a").first().triggerHandler "click"

      normalized = normalizeText element.find(".selected-items-text").text()
      expect(normalized).toBe "2 items selected."

  context "when clicking on the 'apply' button", ->
    beforeEach ->
      setUp()
      scope.$apply -> scope.delegate.selectPage()

    it "evaluates the evaluateOnApplyFunction in the delegate", ->
      spyOn element.isolateScope().actionBar, "triggerApply"

      element.find("button").triggerHandler "click"
      expect(element.isolateScope().actionBar.triggerApply).toHaveBeenCalled()

  context "when 'availableActions' are provided", ->
    it "renders the dropdown select", ->
      setUp()
      scope.$apply -> scope.delegate.selectPage()

      expect(element.find("select").length).toBe 1

  context "when no 'availableActions' are provided", ->
    it "does not render the dropdown select", ->
      setUp({delegateOptions: {availableActions: null}})
      scope.$apply -> scope.delegate.selectPage()

      expect(element.find("select").length).toBe 0
