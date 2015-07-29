context = describe
describe 'ThemisComponents: Service: thModalManager', ->
  ModalManager = httpBackend = null

  beforeEach ->
    module 'ThemisComponents'

    inject (_ModalManager_, _$httpBackend_) ->
      ModalManager = _ModalManager_
      httpBackend = _$httpBackend_

  afterEach ->
    httpBackend.verifyNoOutstandingExpectation()
    httpBackend.verifyNoOutstandingRequest()

  performAction = (template, name, valid) ->
    ModalManager.showModal(template, {}, name || template)
    if valid
      httpBackend.expect('GET', template).respond(200, "<h3>Hello World</h3>")
    else
      httpBackend.expect('GET', template).respond(404, '')
    httpBackend.flush()

  it 'should exist', ->
    expect(!!ModalManager).toBe true

  describe '#showModal()', ->

    context "with valid template", ->
      beforeEach ->
        performAction("validTemplate.html", "valid", true)

      it 'add modal to modals array', ->
        expect(ModalManager.modals.length).toBe 1

      it 'has correct content', ->
        expect(ModalManager.modals[0].content).toBe "<h3>Hello World</h3>"

      it 'has correct name', ->
        expect(ModalManager.modals[0].name).toBe "valid"

    context 'with no name', ->

      it "defaults name to template string", ->
        performAction("validTemplate.html", "", true )
        expect(ModalManager.modals[0].name).toBe "validTemplate.html"

    context "with invalid template", ->

      it 'rejects template silently', ->
        performAction("invalidTemplate.html", 'invalid', false)
        expect(ModalManager.modals.length).toBe 0

  describe '#removeModal()', ->

    beforeEach ->
      performAction("validTemplate.html", "valid", true)

    it 'removes modal if it exists in array', ->
      ModalManager.removeModal("valid")
      expect(ModalManager.modals.length).toBe 0

    it "no change if it doesn't exist", ->
      ModalManager.removeModal("invalid")
      expect(ModalManager.modals.length).toBe 1

  describe "modals", ->

    it "returns an array", ->
      modals = ModalManager.modals
      expect(modals instanceof Array).toBe true
