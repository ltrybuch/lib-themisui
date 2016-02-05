describe 'withLabel', ->
  element = null

  context "with th-radio-group", ->
    beforeEach ->
      additions = {change: -> alert "alerting!"}
      model = 1
      {element} = compileDirective("""
        <th-radio-group ng-model="model" ng-change="change()">
          <th-radio-button with-label="one" value="1"></th-radio-button>
          <th-radio-button with-label="two" value="2"></th-radio-button>
        </th-radio-group>
      """, additions)

    it "appends inline label instead of prepends label", ->
      expect(element.find("span").hasClass("inline label-text")).toBe true

    it "adds 'with-label' value to label", ->
      expect(element.text()).toMatch "one"

    context "when clicking label with an ng-change attribute", ->
      beforeEach ->
        spyOn window, 'alert'
        element.children().last().triggerHandler 'click'

      it "executes ng-change function", ->
        expect(window.alert).toHaveBeenCalledWith "alerting!"

      it "executes the ng-change only once", ->
        expect(window.alert.calls.count()).toEqual 1
