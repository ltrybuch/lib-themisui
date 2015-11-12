context = describe

describe 'thWithLabel', ->
  element = null

  context 'with simple example', ->
    beforeEach ->
      element = compileDirective("""
        <th-input with-label="name"></th-input>
      """).element
    it "wraps input in a label element", ->
      expect(element.parent)
