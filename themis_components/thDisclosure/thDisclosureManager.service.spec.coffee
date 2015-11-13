context = describe
describe 'ThemisComponents: Service: thDisclosureManager', ->
  DisclosureManager = null

  beforeEach ->
    module 'ThemisComponents'

    inject (_DisclosureManager_) ->
      DisclosureManager = _DisclosureManager_

  it 'should exist', ->
    expect(DisclosureManager?).toBe true

  it 'should register and trigger handlers', ->
    uniqueId = 'uniqueId'
    handlerCalled = false
    handler = -> handlerCalled = true
    DisclosureManager.onToggle uniqueId, handler
    DisclosureManager.toggle uniqueId
    expect(handlerCalled).toBe true
