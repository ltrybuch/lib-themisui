context = describe

describe 'withLabel', ->
  element = null

  context "with th-switch", ->
    beforeEach ->
      scopeAdditions =
        onChange: -> alert "Alerting!"
        model: false
      {element} = compileDirective("""
        <th-switch
          with-label="switch name"
          ng-model="model"
          ng-change="onChange()"
          >
        </th-switch>
      """, scopeAdditions)

    it "appends inline label instead of prepends label", ->
      expect(element.next().is("span.inline.label-text")).toBe true

    it "adds 'with-label' value to label", ->
      expect(element.next().text()).toMatch "switch name"

    context "when clicking label with an ng-change attribute", ->
      beforeEach ->
        spyOn window, 'alert'
        element.parent().triggerHandler 'click'

      it "executes ng-change function", ->
        expect(window.alert).toHaveBeenCalledWith 'Alerting!'

      it "executes the ng-change only once", ->
        expect(window.alert.calls.count()).toEqual 1
