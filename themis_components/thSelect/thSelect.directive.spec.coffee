context = describe
describe "ThemisComponents: Directive: thSelect", ->
  element = optionsWithoutPlaceholder = scope = scopeAdditions = null
  beforeEach -> scopeAdditions = {}

  describe "using an array of options", ->
    beforeEach ->
      scopeAdditions.options = [
        {name: "Darth", value: "Sith Lord"}
        {name: "Luke", value: "Jedi Knight"}
      ]
      scopeAdditions.choice = scopeAdditions.options[0]
      {element, scope} = compileDirective """
        <th-select name="faction" options="options" ng-model="choice">
        </th-select>""", scopeAdditions
      optionsWithoutPlaceholder = element.find("option:not([ng-show])")

    it "has the correct number option elements", ->
      expect(optionsWithoutPlaceholder.length).toBe scope.options.length

    it "assigns attr 'selected' to matching ng-model option", ->
      expect(optionsWithoutPlaceholder.filter("[selected]").val()).toMatch "Sith Lord"
      expect(optionsWithoutPlaceholder.not(":selected").val()).toMatch "Jedi Knight"

    it "assigns attr 'name' to select", ->
      expect(element.find("select")[0].hasAttribute("name")).toBe true
      expect(element.find("select").attr("name")).toMatch "faction"

    it "assigns selected value to text of visible select replacement", ->
      expect(element.find(".selected-text").text()).toMatch "Darth"

    it "replacement select has icon with class 'fa fa-caret-down'", ->
      expect(element.find(".text-wrapper > i").hasClass("fa-caret-down")).toBe true

    it "value on select to equal ng-model.value", ->
      expect(element.find("select").val()).toEqual "Sith Lord"

    context "without placeholder attr", ->
      it "prepends a hidden 'blank' option element to the select", ->
        expect(element.find("option").first().val()).toMatch ""
        expect(element.find("option").first().text()).toMatch ""
        expect(element.find("option").first().hasClass("ng-hide")).toBe true

  describe "when disabled", ->
    beforeEach ->
      scopeAdditions.options = [
        {name: "Darth", value: "Sith Lord"}
        {name: "Luke", value: "Jedi Knight"}
      ]
      scopeAdditions.choice = scopeAdditions.options[0]
      {element} = compileDirective """
        <th-select options="options" ng-disabled="true" ng-model="choice">
        </th-select>""", scopeAdditions

      it "disables select", ->
        expect(element.find("select").attr("disabled")).toEqual "disabled"

      it "adds class 'disabled' to the text wrapper div", ->
        expect(element.find(".text-wrapper").hasClass("disabled")).toBe true

  describe "with a placeholder attr", ->
    beforeEach ->
      scopeAdditions.options = [
        {name: "Darth", value: "Sith Lord"}
        {name: "Luke", value: "Jedi Knight"}
      ]
      {element, scope} = compileDirective """
        <th-select placeholder="Pick a side.." options="options" ng-model="choice">
        </th-select>""", scopeAdditions

    context "and no ng-model attr", ->
      it "sets the visible text to placeholder value", ->
        expect(element.find(".selected-text").text()).toMatch "Pick a side.."

    context "and a ng-model attr", ->
      it "will instead set the visible text to the selected option", ->
        scope.$apply ->
          scope.choice = scope.options[0]
        expect(element.find(".selected-text").text()).toMatch "Darth"

    context "when select changes", ->
      beforeEach ->
        element.find("select").val scope.options[1].value
        element.find("select").triggerHandler 'change'

      it "updates select value", ->
        expect(element.find("select").val()).toMatch "Jedi Knight"
        expect(element.find('option:selected').text()).toMatch 'Luke'

      it "updates the model data", ->
        model = scope.$$childHead.select.ngModel
        expect(model).toEqual element.scope().options[1]

    context "when select clicked", ->
      it "toggles 'has-focus' class to inner element", ->
        element.find("select").triggerHandler "focus"
        expect(element.find(".text-wrapper").hasClass('has-focus')).toBe true
        element.find("select").triggerHandler "blur"
        expect(element.find(".text-wrapper").hasClass('has-focus')).toBe false

  describe "with an ng-change attr", ->
    beforeEach ->
      scopeAdditions.options = [{name: "One", value: 2}, {name: "two", value: 2}]
      scopeAdditions.onChange = -> alert "changed"
      {element} = compileDirective """
        <th-select options="options" ng-change="onChange()" ng-model="choice">
      </th-select>""", scopeAdditions

    it "when select is changed executes the change function", ->
      spyOn window, 'alert'
      element.find('select').triggerHandler 'change'
      expect(window.alert).toHaveBeenCalledWith 'changed'

  describe "using HTML option elements", ->
    beforeEach ->
      scopeAdditions.model = "1"
      {element, scope} = compileDirective """
        <th-select
          name="lightsaber"
          ng-required="true"
          ng-disabled="true"
          ng-model="model">
          <option value="1" selected>Green</option>
          <option value="2">Blue</option>
        </th-select>""", scopeAdditions
      optionsWithoutPlaceholder = element.find("option:not([ng-show])")

    it "assigns attr 'name' to select", ->
      expect(element.find("select").attr("name")).toMatch "lightsaber"
      expect(element.find("select")[0].hasAttribute("name")).not.toBe undefined

    it "assigns 'selected' value to select", ->
      expect(element.find("select").val()).toEqual "1"

    it "assigns 'required' attr to select", ->
      expect(element.find("select")[0].hasAttribute("required")).toEqual true

    it "transcludes the passed in options", ->
      expect(optionsWithoutPlaceholder.length).toEqual 2

    it "sets the visible text to the selected name", ->
      expect(element.find("option:selected").text()).toMatch "Green"
      expect(element.find(".selected-text").text()).toMatch "Green"

    context "on select change", ->
      beforeEach ->
        element.find("select").val("2").triggerHandler "change"

      it "updates the visible text to the selected name", ->
        expect(element.find(".selected-text").text()).toMatch "Blue"

      it "updates the model value", ->
        model = scope.$$childHead.select.ngModel
        expect(model).toEqual {name: "Blue", value: "2"}

    context "when disabled", ->
      it "disables select", ->
        expect(element.find("select").attr("disabled")).toEqual "disabled"

      it "adds class 'disabled' to the text wrapper div", ->
        expect(element.find(".text-wrapper").hasClass("disabled")).toBe true
