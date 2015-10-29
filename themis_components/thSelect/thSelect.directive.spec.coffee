context = describe
describe "ThemisComponents: Directive: thSelect", ->
  element = null

  context "using an array of options", ->
    context "when enabled", ->
      beforeEach ->
        scopeAdditions = {}
        scopeAdditions.options = [{name: "Darth", value: "Sith Lord"}, {name: "Luke", value: "Jedi Knight"}]
        scopeAdditions.choice = scopeAdditions.options[0]
        template = """<th-select name="faction" options="options" ng-model="choice"></th-select>"""
        element = compileDirective(template, scopeAdditions).element

      it "has the correct number option elements", ->
        ctrl = element.scope().$$childHead.select
        expect(element.find("option").length).toBe ctrl.options.length

      it "assigns attr 'selected' to selected option", ->
        expect(element.find("option:selected")[0].value).toMatch "Sith Lord"
        expect(element.find("option").not(":selected")[0].value).toMatch "Jedi Knight"

      it "assigns attr 'name' to select", ->
        expect(element.find("select").attr("name")?).toBe true
        expect(element.find("select").attr("name")).toMatch "faction"

      it "assigns selected value to text of visible select replacement", ->
        expect(element.find(".selected-text").text()).toMatch "Darth"

      it "replacement select has icon with class 'fa fa-caret-down'", ->
        expect(element.find(".selected-text > i").hasClass("fa-caret-down")).toBe true

      it "value on select to equal select value", ->
        expect(element.find("select")[0].value).toEqual "Sith Lord"

    context "when disabled", ->
      beforeEach ->
        scopeAdditions = {}
        scopeAdditions.options = [{name: "Darth", value: "Sith Lord"}, {name: "Luke", value: "Jedi Knight"}]
        scopeAdditions.choice = scopeAdditions.options[0]
        disabled = """<th-select name="faction" options="options" disabled ng-model="choice"></th-select>"""
        element = compileDirective(disabled, scopeAdditions).element

      it "disables select", ->
        expect(element.find("select").attr("disabled")).toEqual "disabled"

    context "when select changes", ->
      beforeEach ->
        element.find("select").val element.find("option").eq(1).val()
        element.find("select").triggerHandler 'change'

      it "updates select value", ->
        expect(element.find("select")[0].value).toMatch "Jedi Knight"
        expect(element.find('option:selected').text()).toMatch 'Luke'

      it "updates the model data", ->
        model = element.scope().$$childHead.select.ngModel
        expect(model).toEqual element.scope().options[1]

    context "when select clicked", ->
      it "adds class 'has-focus' to inner element", ->
        element.find("select").triggerHandler "focus"
        expect(element.find(".selected-text").hasClass('has-focus')).toBe true

      it "removes class 'has-focus' from inner element", ->
        element.find("select").triggerHandler "blur"
        expect(element.find(".selected-text").hasClass('has-focus')).toBe false

  context "using HTML option elements", ->
    context "enabled", ->
      beforeEach ->
        template = """
          <th-select name="lightsaber">
            <option value="1">Green</option><option value="2">Blue</option>
          </th-select>
        """
        element = compileDirective(template).element

      it "assigns attr 'name' to select", ->
        expect(element.find("select").attr("name")).toMatch "lightsaber"
        expect(element.find("select").attr("name")).not.toBe undefined

      it "assigns default value to select", ->
        expect(element.find("select").val()).toEqual "1"

      it "transcludes the passed in options", ->
        expect(element.find("option").length).toEqual 2

      it "default visible text to 'Choose…'", ->
        expect(element.find(".selected-text").text()).toMatch "Choose…"

      context "on select change", ->
        beforeEach ->
          element.find("select").val element.find("option").eq(1).val()
          element.find("select").triggerHandler "change"

        it "updates select value", ->
          expect(element.find("select")[0].value).toMatch "2"
          expect(element.find('option:selected').val()).toMatch '2'

    context "when disabled", ->
      beforeEach ->
        template = """<th-select disabled name="lightsaber"><option value="1">Green</option></th-select>"""
        element = compileDirective(template).element

      it "disables the select element", ->
        expect(element.find("select").attr("disabled")).toEqual "disabled"
