context = describe
describe 'ThemisComponents: Service: thDisclosureManager', ->
  DisclosureManager = uniqueId = null
  toggleOpenHandlerCalled = toggleCloseHandlerCalled = toggleHandler = null
  contentOpenHandlerCalled = contentCloseHandlerCalled = contentHandler = null

  beforeEach ->
    module 'ThemisComponents'

    inject (_DisclosureManager_) ->
      DisclosureManager = _DisclosureManager_

    uniqueId = 'uniqueId'

    toggleOpenHandlerCalled = false
    toggleCloseHandlerCalled = false
    toggleHandler =
      handleOpen: -> toggleOpenHandlerCalled = true
      handleClose: -> toggleCloseHandlerCalled = true
    contentOpenHandlerCalled = false
    contentCloseHandlerCalled = false
    contentHandler =
      handleOpen: -> contentOpenHandlerCalled = true
      handleClose: -> contentCloseHandlerCalled = true

  it 'should exist', ->
    expect(DisclosureManager?).toBe true

  describe '#registerDisclosureToggle()', ->
    it 'registers and triggers the toggle handler', ->
      DisclosureManager.registerDisclosureToggle uniqueId, toggleHandler
      DisclosureManager.updateState uniqueId, true
      expect(toggleOpenHandlerCalled).toBe true

  describe '#registerDisclosureContent()', ->
    it 'registers and triggers the content handler', ->
      DisclosureManager.registerDisclosureContent uniqueId, contentHandler
      DisclosureManager.updateState uniqueId, true
      expect(contentOpenHandlerCalled).toBe true

  describe '#updateState()', ->
    it 'updates the disclosure state and calls the handlers', ->
      DisclosureManager.registerDisclosureToggle uniqueId, toggleHandler
      DisclosureManager.registerDisclosureContent uniqueId, contentHandler

      DisclosureManager.updateState uniqueId, false
      expect(toggleCloseHandlerCalled).toBe true
      expect(contentCloseHandlerCalled).toBe true
      
      DisclosureManager.updateState uniqueId, true
      expect(toggleOpenHandlerCalled).toBe true
      expect(contentOpenHandlerCalled).toBe true
