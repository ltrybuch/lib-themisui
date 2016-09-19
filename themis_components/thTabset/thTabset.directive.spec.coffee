{
  compileDirective
} = require "spec_helpers"

describe 'ThemisComponents: Directive: thTabset', ->
  element = validTemplate = ngClickTemplate = scope = tabs = null
  badgeValue = 99
  validTemplate = """
    <div th-tabset>
      <div th-tab name="Tab One">
        <h4>Tab One</h4>
        <p>Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do
           eiusmod tempor incididunt ut labore et dolore magna aliqua.</p>
      </div>
      <div th-tab name="Tab One">
        <h4>Tab One</h4>
        <p>Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do
           eiusmod tempor incididunt ut labore et dolore magna aliqua.</p>
      </div>
    </div>
  """
  ngClickTemplate = """
    <div th-tabset>
      <div th-tab name="Tab One" ng-click="alert('one')"></div>
      <div th-tab name="Tab Two" ng-click="alert('two')"></div>
    </div>
  """
  activeTabTemplate = """
    <div th-tabset active-tab="activeTabName">
      <div th-tab name="Tab One"></div>
      <div th-tab name="Tab Two"></div>
    </div>
  """

  badgeTemplate = """
    <div th-tabset>
      <div th-tab name="Tab One" badge="#{badgeValue}"></div>
      <div th-tab name="Tab Two"></div>
    </div>
  """

  beforeEach angular.mock.module "ThemisComponents"

  describe "with a valid template", ->
    beforeEach -> {element} = compileDirective validTemplate

    it 'should create a tab bar', ->
      expect(element.find('.th-tab-bar').length).toBe 1

    it 'should create a content area', ->
      expect(element.find('.th-tabset-content').length).toBe 1

    it 'should default to the first tab being visible', ->
      expect(element.find('.th-tab-bar a').first().hasClass('active')).toBe true
      expect(element.find('.th-tab-bar a').last().hasClass('active')).toBe false

    it 'should switch to the second tab if clicked', ->
      element.find('.th-tab-bar a').last().click()
      expect(element.find('.th-tab-bar a').first().hasClass('active')).toBe false
      expect(element.find('.th-tab-bar a').last().hasClass('active')).toBe true

  describe "with an ngClick attribute", ->
    beforeEach ->
      additions = {alert: (tab) -> alert tab}
      {element} = compileDirective ngClickTemplate, additions

    it 'should trigger the ng-click function on tab click', ->
      spyOn window, 'alert'
      element.find('.th-tab-bar a').first().triggerHandler 'click'
      expect(window.alert).toHaveBeenCalledWith 'one'

      element.find('.th-tab-bar a').last().triggerHandler 'click'
      expect(window.alert).toHaveBeenCalledWith 'two'

  describe "with 'activeTab' attribute set", ->
    beforeEach ->
      additions = {activeTabName: "Tab Two"}
      {element, scope} = compileDirective activeTabTemplate, additions

    it "uses the 'active-tab' attr to set the correct tab", ->
      tabs = element.find(".th-tab-bar a")
      expect(tabs.first().hasClass('active')).toBe false
      expect(tabs.last().hasClass('active')).toBe true

    it "updating 'active-tab' attr update the active tab", ->
      tabs = element.find(".th-tab-bar a")
      expect(tabs.first().hasClass('active')).toBe false
      expect(tabs.last().hasClass('active')).toBe true
      scope.$apply -> scope.activeTabName = "Tab One"
      expect(tabs.first().hasClass('active')).toBe true
      expect(tabs.last().hasClass('active')).toBe false

  describe "with 'badge' attribute set", ->
    beforeEach ->
      {element, scope} = compileDirective badgeTemplate
      tabs = element.find(".th-tab-bar a")

    it "creates a badge element", ->
      firstTabBadge = tabs.first().find("span")
      secondTabBadge = tabs.last().find("span")

      expect(firstTabBadge.length).toBe 1
      expect(parseInt firstTabBadge.text()).toBe badgeValue
      expect(secondTabBadge.length).toBe 0
