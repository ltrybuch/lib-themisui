context = describe
describe 'ThemisComponents: Service: thFlashManager', ->
  FlashManager = null

  beforeEach ->
    module 'ThemisComponents'

    inject (_FlashManager_) ->
      FlashManager = _FlashManager_

  it 'should exist', ->
    expect(FlashManager?).toBe true

  describe '#showFlash()', ->
    it 'should populate the flashMessage object', ->
      FlashManager.showFlash "Risus Lorem", "success"
      expect(FlashManager.flashMessage).toEqual {message: 'Risus Lorem', type: 'success'}

  describe '#hideFlash()', ->
    it 'should populate the flashMessage object', ->
      FlashManager.hideFlash
      expect(FlashManager.flashMessage).toEqual {}
