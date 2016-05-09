{
  compileDirective
} = require "spec_helpers"
context = describe

describe "ThemisComponents: Directive: thSelect", ->
  element = optionsWithoutPlaceholder = scope = scopeAdditions = options = select = null

  beforeEach angular.mock.module "ThemisComponents"
  beforeEach -> scopeAdditions = {}

  describe "using an array of options", ->
    beforeEach ->
      scopeAdditions.options = [
        {name: "Darth", value: "Sith Lord"}
        {name: "Luke", value: "Jedi Knight"}
      ]
      scopeAdditions.choice = scopeAdditions.options[0]
      {element, scope} = compileDirective """
        <th-select name="faction" condensed="true" options="options" ng-model="choice">
        </th-select>""", scopeAdditions
      select = element.find "select"
      options = element.find "option"
      optionsWithoutPlaceholder = element.find "option:not([ng-show])"

    it "has the correct number option elements", ->
      expect(optionsWithoutPlaceholder.length).toBe scope.options.length

    it "assigns attr 'selected' to matching ng-model option", ->
      expect(select.find("option:selected").val()).toMatch "Sith Lord"

    it "assigns attr 'name' to select", ->
      expect(select.attr("name")).toMatch "faction"

    it "assigns selected value to text of visible select replacement", ->
      expect(element.find(".selected-text").text()).toMatch "Darth"

    it "replacement select has icon with class 'fa fa-caret-down'", ->
      expect(element.find(".text-wrapper > i").hasClass("fa-caret-down")).toBe true

    it "value on select to equal ng-model.value", ->
      expect(select.val()).toEqual "Sith Lord"

    context "without placeholder attr", ->
      it "prepends a hidden 'blank' option element to the select", ->
        expect(options.first().val()).toMatch ""
        expect(options.first().text()).toMatch ""
        expect(options.first().hasClass("ng-hide")).toBe true

    context "with 'condensed' attribute set to true", ->
      it "adds class 'condensed' to the select wrapper", ->
        expect(element.hasClass("condensed")).toBe true

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
      select = element.find "select"

    context "and no ng-model attr", ->
      it "th-select's text is set to placeholder's text", ->
        expect(element.find(".selected-text").text()).toMatch "Pick a side.."

    context "and a ng-model attr", ->
      it "will instead set the visible text to the selected option", ->
        scope.$apply -> scope.choice = scope.options[0]
        expect(element.find(".selected-text").text()).toMatch "Darth"

    context "when select changes", ->
      beforeEach ->
        select.val scope.options[1].value
        select.triggerHandler 'change'

      it "updates select value", ->
        expect(select.val()).toMatch "Jedi Knight"
        expect(element.find('option:selected').text()).toMatch 'Luke'

      it "updates the model data", ->
        model = scope.$$childHead.select.ngModel
        expect(model).toEqual element.scope().options[1]

    context "when select clicked", ->
      it "toggles 'has-focus' class to inner element", ->
        select.triggerHandler "focus"
        expect(element.find(".text-wrapper").hasClass('has-focus')).toBe true
        select.triggerHandler "blur"
        expect(element.find(".text-wrapper").hasClass('has-focus')).toBe false

  describe "with options that are without name-value fields", ->
    beforeEach ->
      scopeAdditions.options = [
        {altNameField: "Darth", altValueField: "Sith Lord"}
        {altNameField: "Luke", altValueField: "Jedi Knight"}
      ]

    describe "with name-field and value-field attrs", ->
      beforeEach ->
        {element} = compileDirective """
          <th-select
            options="options"
            ng-model="choice"
            name-field="altNameField"
            value-field="altValueField"
            >
        </th-select>""", scopeAdditions

        select = element.find "select"
        select.val scope.options[1].value
        select.triggerHandler 'change'

      it "updates select value", ->
        expect(select.val()).toMatch "Jedi Knight"
        expect(element.find('option:selected').text()).toMatch 'Luke'

    describe "without name-field and value-field attrs", ->
      beforeEach ->
        {element} = compileDirective """
          <th-select options="options" ng-change="onChange()" ng-model="choice">
        </th-select>""", scopeAdditions

        select = element.find "select"
        select.val scope.options[1].value
        select.triggerHandler 'change'

      it "should not update select", ->
        expect(select.val()).not.toMatch "Jedi Knight"
        expect(element.find('option:selected').text()).not.toMatch 'Luke'

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
      select = element.find("select")

    it "assigns attr 'name' to select", ->
      expect(select.attr("name")).toMatch "lightsaber"

    it "assigns 'selected' value to select", ->
      expect(select.val()).toEqual "1"

    it "assigns 'required' attr to select", ->
      expect(select.attr("required")).toEqual "required"

    it "transcludes the passed in options", ->
      expect(optionsWithoutPlaceholder.length).toEqual 2

    it "sets the visible text to the selected name", ->
      expect(element.find("option:selected").text()).toMatch "Green"
      expect(element.find(".selected-text").text()).toMatch "Green"

    context "on select change", ->
      beforeEach ->
        select.val("2").triggerHandler "change"

      it "updates the visible text to the selected name", ->
        expect(element.find(".selected-text").text()).toMatch "Blue"

      it "updates the model value", ->
        model = scope.$$childHead.select.ngModel
        expect(model).toEqual {name: "Blue", value: "2"}

    context "when disabled", ->
      it "disables select", ->
        expect(select.attr("disabled")).toEqual "disabled"

      it "adds class 'disabled' to the text wrapper div", ->
        expect(element.find(".text-wrapper").hasClass("disabled")).toBe true

  describe "using both an array and option elements", ->
    beforeEach ->
      scopeAdditions.options = [
        {name: "Tatooine", value: 7}
        {name: "Hoth", value: 2}
      ]
      scopeAdditions.choice = scopeAdditions.options[0]
      {element, scope} = compileDirective """
        <th-select ng-model="choice" options="options" placeholder="Pick a planet">
          <option value="3">Endor</option>
          <option value="5">Alderaan</option>
        </th-select>""", scopeAdditions
      options = element.find "option"
      optionsWithoutPlaceholder = element.find "option:not([ng-show])"

    it "has correct amount of options", ->
      expect(optionsWithoutPlaceholder.length).toEqual 4

    it "assigns the transcluded options to the bottom of the list of options", ->
      expect(optionsWithoutPlaceholder.last().val()).toEqual "5"
      expect(optionsWithoutPlaceholder.last().text()).toEqual "Alderaan"

      expect(optionsWithoutPlaceholder.last().prev().val()).toEqual "3"
      expect(optionsWithoutPlaceholder.last().prev().text()).toEqual "Endor"

    it "assigns the options in the array to the top of the list of options", ->
      expect(optionsWithoutPlaceholder.first().val()).toBe "7"
      expect(optionsWithoutPlaceholder.first().text()).toBe "Tatooine"

      expect(optionsWithoutPlaceholder.first().next().val()).toBe "2"
      expect(optionsWithoutPlaceholder.first().next().text()).toBe "Hoth"

    it "assigns the placeholder option as the top option", ->
      expect(options.first().val()).toEqual ""
      expect(options.first().text()).toMatch "Pick a planet"

    context "when ng-model references an object in the options array", ->
      it "th-select's value to equal ng-model's value", ->
        expect(element.find("select").val()).toMatch "7"

      it "th-select's text to equals the ng-model's name", ->
        expect(element.find(".selected-text").text()).toMatch 'Tatooine'

    context "when ng-model is blank", ->
      beforeEach -> scope.$apply -> scope.choice = ""

      it "th-select's value is set to placholder's value", ->
        expect(element.find("select").val()).toEqual ""

      it "th-select's text is set to placeholder's text", ->
        expect(element.find(".selected-text").text()).toMatch "Pick a planet"
