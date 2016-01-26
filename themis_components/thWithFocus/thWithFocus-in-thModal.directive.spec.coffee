context = describe

describe "ThemisComponents: Directive: withFocus", ->
  element = timeout = ModalManager = httpBackend = null

  appendToBody = (element) -> element.appendTo document.body
  flush = -> timeout.flush 302 # th-modal's CSS transition time.

  beforeEach ->
    inject ($timeout) -> timeout = $timeout
    jasmine.addMatchers
      toHaveFocus: ->
        compare: (element) ->
          pass: document.activeElement is element[0]

  context "with th-modal", ->
    beforeEach ->
      inject (_ModalManager_, $httpBackend) ->
        ModalManager = _ModalManager_
        httpBackend = $httpBackend
    afterEach ->
      httpBackend.verifyNoOutstandingExpectation()
      httpBackend.verifyNoOutstandingRequest()

    ["input", "select"].forEach (type) ->
      it "sets focus on open", ->
        {element} = compileDirective """<th-modal-anchor></th-modal-anchor>"""
        appendToBody element
        template = """<#{type} with-focus></#{type}>"""
        ModalManager.show path: "focus.html"
        httpBackend.expect("GET", "focus.html").respond(template)
        httpBackend.flush()
        flush()
        expect(element.find("#{type}")).toHaveFocus()
