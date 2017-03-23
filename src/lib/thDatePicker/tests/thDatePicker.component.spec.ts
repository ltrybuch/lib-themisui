import * as moment from "moment";
import * as angular from "angular";
let SpecHelpers: any = require("spec_helpers.coffee");

describe("ThemisComponents: Component: DatepickerController", () => {

  const aDate = moment("2020-12-31");
  const defaultDateFormat = "yyyy-MM-dd";

  beforeEach(angular.mock.module("ThemisComponents"));

  it("creates a date out of a test date with a default format " + defaultDateFormat, () => {
    const template = `<th-date-picker ng-model="date"></th-date-picker>`;
    const {element} = SpecHelpers.compileDirective(template, {date: aDate});

    expect(element.find("input").val()).toBe("2020-12-31");
  });

  // test the 3 valid date formats
  const dateFormat = ["yyyy-MM-dd", "MM/dd/yyyy", "dd/MM/yyyy"];
  const dateFormated = ["2020-12-31", "12/31/2020", "31/12/2020"];

  for (let i = 0, l = dateFormat.length; i < l; i++) {
    const format = dateFormat[i];
    const dateStr = dateFormated[i];

    it(`parses a valid date into format(${ format })`, () => {
      const scopeAdditions = {date: aDate, dateFormat: format};
      const template = `<th-date-picker ng-model="date" date-format="{{dateFormat}}"></th-date-picker>`;
      const {element} = SpecHelpers.compileDirective(template, scopeAdditions);

      expect(element.find("input").val()).toBe(dateStr);
    });

  }

  // test all the options
  let scope: any = {};

  describe("With the placeholder attribute set", () => {
    it("creates an datepicker with a placeholder", () => {
      scope.placeholder = "Type a foo...";
      const template = `<th-date-picker ng-model="date" placeholder="{{placeholder}}"></th-date-picker>`;
      const {element} = SpecHelpers.compileDirective(template, scope);

      expect(element.attr("placeholder")).toEqual("Type a foo...");
    });
  });

  describe("With the name attribute set", () => {
    it("creates an datepicker with a name", () => {
      scope.name = "foo";
      const template = `<th-date-picker  ng-model="date" name="{{name}}"></th-date-picker>`;
      const {element} = SpecHelpers.compileDirective(template, scope);

      expect(element.attr("name")).toEqual("foo");
    });
  });

  describe("With the condensed attribute set", () => {
    it("creates an datepicker with condensed styling", () => {
      scope.condensed = true;
      const template = `<th-date-picker  ng-model="date" condensed="{{this.condensed}}"></th-date-picker>`;
      const {element} = SpecHelpers.compileDirective(template, scope);

      expect(element.attr("condensed")).toEqual("true");
    });
  });

  describe("When template specifies on-change callback", () => {
    it("should trigger callback", () => {
      scope.callback = (): undefined => undefined;
      spyOn(scope, "callback");
      const template = `<th-date-picker ng-model="date" on-change="callback"></th-date-picker>`;
      const {element} = SpecHelpers.compileDirective(template, scope);

      element.find("input").triggerHandler("click");
      const firstDate = $("body").find(".k-calendar-container[aria-hidden='false']").find("td a").first();
      firstDate.click();

      expect(scope.callback).toHaveBeenCalled();
      $(".k-animation-container").remove();
    });
  });

  describe("When max is specified", () => {
    it("should not allow dates after", () => {
      scope.max = moment();
      const availableDate = moment().date();
      const unavailableDate = moment().add(1, "days").date();
      const template = `<th-date-picker ng-model="date" max="max"></th-date-picker>`;

      const {element} = SpecHelpers.compileDirective(template, scope);
      element.find("input").triggerHandler("click");

      expect($(`table a:contains('${ availableDate }')`).text()).toBe(availableDate.toString());
      expect($(`table a:contains('${ unavailableDate }')`).text()).toBe("");
      $(".k-animation-container").remove();
    });
  });

  describe("When min is specified", () => {
    it("should not allow dates before", () => {
      scope.min = moment();
      const availableDate = moment().date();
      const unavailableDate = moment().subtract(1, "days").date();
      const template = `<th-date-picker ng-model="date" min="min"></th-date-picker>`;

      const {element} = SpecHelpers.compileDirective(template, scope);
      element.find("input").triggerHandler("click");

      expect($(`table a:contains('${ availableDate }')`).text()).toBe(availableDate.toString());
      expect($(`table a:contains('${ unavailableDate }')`).text()).toBe("");
      $(".k-animation-container").remove();
    });
  });
});
