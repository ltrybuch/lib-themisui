context = describe
describe "ThemisComponents: Directive: thModalAnchor", ->
  element = directive = ctrl = ModalManager = httpBackend = null
  beforeEach ->
    directive = compileDirective("<th-modal-anchor></th-modal-anchor>")
    element = directive.element
    ctrl = directive.scope.anchor

    inject (_ModalManager_, $httpBackend) ->
      ModalManager = _ModalManager_
      httpBackend = $httpBackend

  context "with no modals in queue", ->
    it 'inner content is hidden', ->
      expect(element.find("div").length).toBe 0

    it "does not have 'visible' class", ->
      expect(element.find('.visible').length).toBe 0

    describe '#modals', ->
      it 'returns an array', ->
        expect(ctrl.modals instanceof Array).toBe true

      it 'returns an empty array', ->
        expect(ctrl.modals.length).toBe 0

  context "with a modal", ->
    beforeEach ->
      ModalManager.show({path:"example.html"})
      httpBackend.expect('GET', 'example.html').respond("<h3>example</h3>")
      httpBackend.flush()

    afterEach ->
      httpBackend.verifyNoOutstandingExpectation()
      httpBackend.verifyNoOutstandingRequest()

    it "inner content exists", ->
      expect(element.find("div").length).not.toBe 0
      expect(element.find(".th-modal-container").length).toBe 1

    it "assigns modal-data attr to 'modal'", ->
      expect(element.find(".th-modal").attr('modal-data')).toBe "modal"

    it "adds template to modal", ->
      expect(element.find("[th-compile]").html()).toEqual '<h3 class="ng-scope">example</h3>'

    describe '#modals', ->
      it "returns an with one element", ->
        expect(ctrl.modals.length).toBe 1
