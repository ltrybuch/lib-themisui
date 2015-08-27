context = describe
describe 'ThemisComponents: Service: thModalManager', ->
  ModalManager = httpBackend = promise = null

  beforeEach ->
    module 'ThemisComponents'

    inject (_ModalManager_, _$httpBackend_) ->
      ModalManager = _ModalManager_
      httpBackend = _$httpBackend_

  afterEach ->
    httpBackend.verifyNoOutstandingExpectation()
    httpBackend.verifyNoOutstandingRequest()

  performAction = (template, name) ->
    promise = ModalManager.show path: template, name: name || template
    if template == "validTemplate.html"
      httpBackend.expect('GET', template).respond(200, "<h3>Hello World</h3>")
    else
      httpBackend.expect('GET', template).respond(404, '')
    httpBackend.flush()
    promise

  it 'should exist', ->
    expect(ModalManager?).toBe true

  describe '#show()', ->

    context "with valid template", ->
      beforeEach ->
        promise = performAction("validTemplate.html", "valid")

      it "returns a promise", ->
        expect(promise).toBeDefined
        expect(promise.then instanceof Function).toBe true

      it 'add modal to modals array', ->
        expect(ModalManager._modals.length).toBe 1

      it 'has correct content', ->
        expect(ModalManager._modals[0].content).toBe "<h3>Hello World</h3>"

      it 'has correct name', ->
        expect(ModalManager._modals[0].name).toBe "valid"

    context 'with no name', ->

      it "defaults name to template string", ->
        performAction("validTemplate.html", "")
        expect(ModalManager._modals[0].name).toBe "validTemplate.html"

    context "with invalid template", ->

      it 'rejects template silently', ->
        performAction("invalidTemplate.html", 'invalid')
        expect(ModalManager._modals.length).toBe 0

  describe '#dismiss()', ->

    beforeEach ->
      promise = performAction("validTemplate.html", "valid")

    it 'removes modal if it exists in array', ->
      ModalManager.dismiss("valid")
      expect(ModalManager._modals.length).toBe 0

    it "no change if it doesn't exist", ->
      ModalManager.dismiss("invalid")
      expect(ModalManager._modals.length).toBe 1

    it "rejects deferred", ->
      rejected = 2; pending = 0

      expect(promise.$$state.status).toEqual pending
      ModalManager.dismiss("valid")
      expect(promise.$$state.status).toEqual rejected

  describe '#confirm()', ->

    beforeEach ->
      promise = performAction("validTemplate.html", "valid")

    it 'removes modal if it exists in array', ->
      ModalManager.confirm("valid")
      expect(ModalManager._modals.length).toBe 0

    it "no change if it doesn't exist", ->
      ModalManager.confirm("invalid")
      expect(ModalManager._modals.length).toBe 1

    it "resolves deferred", ->
      resolved = 1; pending = 0

      expect(promise.$$state.status).toEqual pending
      ModalManager.confirm("valid")
      expect(promise.$$state.status).toEqual resolved

    it "resolves deferred with optional response", ->
      ModalManager.confirm("valid", "response!")
      promise.then (data) ->
        expect(data).toEqual "response!"


  describe "_modals", ->
    it "returns an array", ->
      modals = ModalManager._modals
      expect(modals instanceof Array).toBe true
