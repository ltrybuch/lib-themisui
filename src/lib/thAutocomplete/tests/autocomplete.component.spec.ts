import * as angular from "angular";
import "angular-mocks";
const SpecHelpers: any = require("spec_helpers");
import { AutocompleteComponentError } from "../autocomplete.errors";
import AutocompleteOptionsFixture from "./fixtures/autocomplete-opts.fixture";

/* tslint:disable:no-shadowed-variable */

describe("ThemisComponents: thAutocomplete : AutocompleteController", () => {

  beforeEach(angular.mock.module("ThemisComponents"));

  describe("Validations", () => {

    it("should throw an error when options object is missing ", () => {
      const invalidTemplate = "<th-autocomplete></th-autocomplete>";
      expect(function() {
        SpecHelpers.compileDirective(invalidTemplate);
      }).toThrow(new AutocompleteComponentError(`You must provide the "options" parameter.`));
    });

    it("should throw an error when the multiple and combobox attributes are set at the same time", () => {
      const invalidTemplate = `<th-autocomplete options="demo.options" multiple combobox></th-autocomplete>`;
      expect(function() {
        SpecHelpers.compileDirective(invalidTemplate, {
          demo: {
            options: AutocompleteOptionsFixture.createAutocompleteConfig().options,
          },
        });
      }).toThrow(new AutocompleteComponentError(`multiple and combobox are mutually exclusive`));
    });

  });

  describe("Creation", () => {

    let scope: any;
    scope = {};

    beforeEach(inject(function(DataSource: any) {
      scope.options = {
        dataSource: DataSource.createDataSource({
          data: [
            {"id": 1, name: "Mike", company: "Clio"},
            {"id": 2, name: "Craig", company: "Clio"},
          ],
        }),
        displayField: "name",
        filterType: "startswith",
      };
    }));

    it("creates an autocomplete", () => {
      const {element} = SpecHelpers.compileDirective(`<th-autocomplete options="options"></th-autocomplete>`, scope);
      expect(element.find(".k-autocomplete").length).toEqual(1);
    });

    describe("with the combobox attribute set to true", () => {
      it("creates a combobox", () => {
        scope.combobox = "true";
        const template = `<th-autocomplete options="options" combobox="{{combobox}}"></th-autocomplete>`;
        const {element} = SpecHelpers.compileDirective(template, scope);
        expect(element.find(".k-combobox").length).toEqual(1);

        describe("with the combobox attribute set to false", () => {
          it("does not create a combobox", () => {
            scope.combobox = "false";
            const template = `<th-autocomplete options="options" combobox="{{combobox}}"></th-autocomplete>`;
            const {element} = SpecHelpers.compileDirective(template, scope);
            expect(element.find(".k-combobox").length).toEqual(0);
          });
        });
      });
    });

    describe("with the multiple attribute set to true", () => {
      it("creates a multiselect", () => {
        scope.multiple = "true";
        const template = `<th-autocomplete options="options" multiple="true"></th-autocomplete>`;
        const {element} = SpecHelpers.compileDirective(template, scope);
        expect(element.find(".k-multiselect").length).toEqual(1);

        describe("with the multiple attribute set to false", () => {
          it("does not create a multiselect", () => {
            scope.multiple = "false";
            const template = `<th-autocomplete options="options" multiple="true"></th-autocomplete>`;
            const {element} = SpecHelpers.compileDirective(template, scope);
            expect(element.find(".k-multiselect").length).toEqual(0);
          });
        });
      });
    });

    describe("with the placeholder attribute set", () => {
      it("creates an autocomplete with a placeholder", () => {
        scope.placeholder = "Type a foo...";
        const template = `<th-autocomplete options="options" placeholder="{{placeholder}}"></th-autocomplete>`;
        const {element} = SpecHelpers.compileDirective(template, scope);
        expect(element.attr("placeholder")).toEqual("Type a foo...");
      });
    });

    describe("with the group-by attribute set", () => {
      it("creates an autocomplete with grouped options", () => {
        scope.groupBy = "company";
        const template = `<th-autocomplete options="options" group-by="{{groupBy}}"></th-autocomplete>`;
        const {element} = SpecHelpers.compileDirective(template, scope);
        expect(element.attr("group-by")).toEqual("company");
      });
    });

    describe("with the show-search-hint attribute set", () => {
      it("creates an autocomplete with a search hint", () => {
        scope.showSearchHint = "true";
        const template = `<th-autocomplete options="options" show-search-hint="{{showSearchHint}}"></th-autocomplete>`;
        const {element} = SpecHelpers.compileDirective(template, scope);
        expect(element.attr("show-search-hint")).toEqual("true");
      });
    });

    describe("with the name attribute set", () => {
      it("creates an autocomplete with a name", () => {
        scope.name = "foo";
        const template = `<th-autocomplete options="options" name="{{name}}"></th-autocomplete>`;
        const {element} = SpecHelpers.compileDirective(template, scope);
        expect(element.attr("name")).toEqual("foo");
      });
    });

    describe("with the condensed attribute set", () => {
      it("creates an autocomplete with condensed styling when set to true", () => {
        scope.condensed = "true";
        const template = `<th-autocomplete options="options" condensed="{{condensed}}"></th-autocomplete>`;
        const {element} = SpecHelpers.compileDirective(template, scope);
        expect(element.attr("condensed")).toEqual("true");
      });

      it("creates an autocomplete with no condensed attribute when condensed is non-truthy", () => {
        scope.condensed = "false";
        const template = `<th-autocomplete options="options" condensed="{{condensed}}"></th-autocomplete>`;
        const {element} = SpecHelpers.compileDirective(template, scope);
        expect(element.attr("condensed")).toEqual("false");
      });
    });
  });
});
