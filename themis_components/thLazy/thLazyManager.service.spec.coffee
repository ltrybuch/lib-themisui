context = describe
describe 'ThemisComponents: Service: thLazyManager', ->
  LazyManager = lazyObject = null

  beforeEach ->
    angular.mock.module 'ThemisComponents'
    lazyObject = {name: "Foo", src: "Bar"}

    inject (_LazyManager_) ->
      LazyManager = _LazyManager_

  it 'should exist', ->
    expect(LazyManager?).toBe true

  describe '#addLazyObject()', ->
    it "adds the object to lazyObjects", ->
      LazyManager.addLazyObject(lazyObject)
      expect(LazyManager._lazyObjects).toEqual {Foo: lazyObject}

  describe '#reload()', ->
    beforeEach ->
      LazyManager.addLazyObject(lazyObject)
      LazyManager._lazyObjects["Foo"].reload = -> return

    it "calls the object's reload function", ->
      LazyManager.reload(lazyObject.name)
      expect(lazyObject.reload).toHaveBeenCalled
