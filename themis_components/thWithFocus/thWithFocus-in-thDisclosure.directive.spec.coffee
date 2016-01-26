context = describe

describe 'ThemisComponent: Directive: withFocus', ->
  element = timeout = null

  appendToBody = (element) -> angular.element('body').append element
  flush = -> timeout.flush 302 # th-modal's CSS transition time

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

      it "sets focus when disclosure is expanded on load", ->
        href = if type is "a" then "href" else ""
        element = compileDirective("""
          <th-disclosure-toggle name="dd" expanded="true"></th-disclosure-toggle>
            <th-disclosure-content name="dd">
              <#{type} #{href} with-focus></#{type}>
            </th-disclosure-content>
          """).element
        appendToBody element
        innerEl = angular.element(element[2]).find("#{type}")
        flush()
        expect(innerEl).toHaveFocus()

  context "on th-components inside th-disclosure", ->
    ["input", "select"].forEach (component) ->
      afterEach ->
        element.remove()

      it "sets focus when disclosure is expanded on load", ->
        element = compileDirective("""
          <th-disclosure-toggle name="dd" expanded="true"></th-disclosure-toggle>
            <th-disclosure-content name="dd">
              <th-#{component} with-focus></th-#{component}>
            </th-disclosure-content>
          """).element
        appendToBody element
        innerEl = angular.element(element[2]).find("#{component}")
        flush()
        expect(innerEl).toHaveFocus()
