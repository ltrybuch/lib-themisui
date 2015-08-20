context = describe
describe "ThemisComponents: Directive: thDropdown", ->
  directive = null
  beforeEach ->
    list = [{name: 'link', url: '/example/link', method: 'GET'}]
    template = """<th-dropdown name="Button" list="list"></th-dropdown>"""
    directive = compileDirective(template)

  # it "is wrapped in a <div> with class 'button-dropdown'", ->
  #   firstEl = directive.element[0]
  #   console.log firstEl
  #   expect(firstEl.className).toBe "button-dropdown"

  # context "when dropdown button is clicked", ->
  #   it "adds a overlay element with class 'th-dropdown-overlay'", ->
