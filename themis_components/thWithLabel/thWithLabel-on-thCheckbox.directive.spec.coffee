context = describe

describe 'withLabel', ->
  element = null

  context "with th-checkbox", ->
    beforeEach ->
      additions = {change: -> alert "alerting!"}
      {element} = compileDirective("""
        <th-checkbox
          with-label="checkbox name"
          ng-model="model"
          ng-change="change()"
          >
        </th-checkbox>
      """, additions)

    it "appends inline label instead of prepends label", ->
      expect(element.next().is("span.inline.label-text")).toBe true

    it "adds 'with-label' value to label", ->
      expect(element.next().text()).toMatch "checkbox name"

    context "when clicking label with an ng-change attribute", ->
      beforeEach ->
        spyOn window, 'alert'
        element.parent().triggerHandler 'click'

      it "executes ng-change function", ->
        expect(window.alert).toHaveBeenCalledWith "alerting!"

      it "executes the ng-change only once", ->
        expect(window.alert.calls.count()).toEqual 1
