context = describe

describe 'ThemisComponent: Directive: withFocus', ->
  element = timeout = null

  appendToBody = (element) -> angular.element('body').append element
  flush = -> timeout.flush 0

  beforeEach ->
    inject ($timeout) -> timeout = $timeout
    jasmine.addMatchers
      toHaveFocus: ->
        compare: (element) ->
          pass: document.activeElement is element[0]

  context "on HTML elements inside th-disclosure", ->
    ["a", "textarea", "select"].forEach (type) ->
      afterEach ->
        element.remove()

      it "sets focus on open", ->
        href = if type is "a" then "href" else ""
        element = compileDirective("""
          <th-disclosure-toggle name="dd"></th-disclosure-toggle>
            <th-disclosure-content name="dd">
              <#{type} #{href} with-focus></#{type}>
            </th-disclosure-content>
          """).element
        appendToBody element
        innerEl = angular.element(element[2]).find("#{type}")
        expect(innerEl).not.toHaveFocus()
        element.find("a").first().triggerHandler "click"
        flush()
        expect(innerEl).toHaveFocus()

  context "on th-components inside th-disclosure", ->
    ["input", "select"].forEach (component) ->
      afterEach ->
        element.remove()

      it "sets focus on open", ->
        element = compileDirective("""
          <th-disclosure-toggle name="dd"></th-disclosure-toggle>
            <th-disclosure-content name="dd">
              <th-#{component} with-focus></th-#{component}>
            </th-disclosure-content>
          """).element
        appendToBody element
        innerEl = angular.element(element[2]).find("#{component}")
        expect(innerEl).not.toHaveFocus()
        element.find("a").first().triggerHandler "click"
        flush()
        expect(innerEl).toHaveFocus()
