context = describe
describe 'ThemisComponents: Service: thDisclosureManager', ->
  DisclosureManager = uniqueId = openHandlerCalled = closeHandlerCalled = toggle = null

  beforeEach ->
    module 'ThemisComponents'

    inject (_DisclosureManager_) ->
      DisclosureManager = _DisclosureManager_

    uniqueId = 'uniqueId'
    openHandlerCalled = false
    closeHandlerCalled = false
    toggle =
      open: -> openHandlerCalled = true
      close: -> closeHandlerCalled = true

  it 'should exist', ->
    expect(DisclosureManager?).toBe true

  describe '#registerDisclosureToggle()', ->
    it 'registers and triggers the toggle handler', ->
      DisclosureManager.registerDisclosureToggle uniqueId, toggle
      DisclosureManager.open uniqueId
      expect(openHandlerCalled).toBe true

  describe '#registerDisclosureToggle()', ->
    it 'registers and triggers the content handler', ->
      DisclosureManager.registerDisclosureContent uniqueId, toggle
      DisclosureManager.open uniqueId
      expect(openHandlerCalled).toBe true

  describe '#toggle()', ->
    it 'toggles the diclosure state and calls the handler', ->
      DisclosureManager.registerDisclosureContent uniqueId, toggle
      DisclosureManager.close uniqueId
      DisclosureManager.toggle uniqueId
      expect(openHandlerCalled).toBe true

  describe '#open()', ->
    it 'calls the open handler', ->
      DisclosureManager.registerDisclosureContent uniqueId, toggle
      DisclosureManager.close uniqueId
      DisclosureManager.open uniqueId
      expect(openHandlerCalled).toBe true

  describe '#close()', ->
    it 'calls the open handler', ->
      DisclosureManager.registerDisclosureContent uniqueId, toggle
      DisclosureManager.open uniqueId
      DisclosureManager.close uniqueId
      expect(closeHandlerCalled).toBe true
