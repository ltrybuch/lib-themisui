context = describe

describe "ThemisComponents: Directive: withFocus", ->
  element = timeout = null

  appendToBody = (element) -> element.appendTo document.body
  flush = -> timeout.flush 302

  beforeEach ->
    inject ($timeout) -> timeout = $timeout
    jasmine.addMatchers
      toHaveFocus: ->
        compare: (element) ->
          pass: document.activeElement is element[0]

  context "with HTML input elements", ->
    ["password", "file", "submit", "email"].forEach (type) ->
      it "supports input type #{type}", ->
        element = compileDirective(
          """<input type="#{type}" with-focus>""").element
        appendToBody element
        flush()
        expect(angular.element(element)).toHaveFocus()

  context "with other HTML elements", ->
    ["a", "textarea", "select"].forEach (type) ->
      it "supports #{type} tags", ->
        href = if type is "a" then "href" else ""
        {element} = compileDirective(
          """<#{type} #{href} with-focus></#{type}>""")
        appendToBody element
        flush()
        expect(angular.element(element)).toHaveFocus()

  context "with th-components", ->
    ["input", "select"].forEach (component) ->
      it "supports #{component}", ->
        {element} = compileDirective(
          """<th-#{component} with-focus><th-#{component}>""")
        appendToBody element
        flush()
        innerEl = angular.element element.find("#{component}")
        expect(innerEl).toHaveFocus()
