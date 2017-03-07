import * as angular from "angular";
import "angular-mocks";
let SpecHelpers: any = require("spec_helpers");
let context = describe;

/* tslint:disable:max-line-length */

describe("ThemisComponents: Component: AutocompleteController", () => {

  beforeEach(angular.mock.module("ThemisComponents"));

  describe("when delegate is not specified", () => {
    it("should throw an error", () => {
      let invalidTemplate = "<th-autocomplete></th-autocomplete>";
      expect( function(){ SpecHelpers.compileDirective(invalidTemplate); } ).toThrow();
    });
  });

  describe("when a delegate is specified", () => {
    let scope: any;
    scope = {};

    beforeEach(inject(function(DataSource: any) {
      scope.dg = {
        dataSource: DataSource.createDataSource({
          data: [
            {"id": 1, name: "Mike", company: "Clio"},
            {"id": 2, name: "Craig", company: "Clio"}
          ]
        }),
        dataTextField: "name",
        filterType: "startswith"
      };
    }));

    it("creates an autocomplete", () => {
      const {element} = SpecHelpers.compileDirective('<th-autocomplete delegate="dg"></th-autocomplete', scope);
      expect(element.find(".k-autocomplete").length).toEqual(1);
    });

    context("with the combobox attribute set to true", () => {
      it("creates a combobox", () => {
        scope.combobox = "true";
        const {element} = SpecHelpers.compileDirective('<th-autocomplete delegate="dg" combobox="{{combobox}}"></th-autocomplete>', scope);
        expect(element.find(".k-combobox").length).toEqual(1);

        context("with the combobox attribute set to false", () => {
          it("does not create a combobox", () => {
            scope.combobox = "false";
            const {element} = SpecHelpers.compileDirective('<th-autocomplete delegate="dg" combobox="{{combobox}}"></th-autocomplete>', scope);
            expect(element.find(".k-combobox").length).toEqual(0);
          });
        });
      });
    });

    context("with the multiple attribute set to true", () => {
      it("creates a multiselect", () => {
        scope.multiple = "true";
        const {element} = SpecHelpers.compileDirective('<th-autocomplete delegate="dg" multiple="true"></th-autocomplete>', scope);
        expect(element.find(".k-multiselect").length).toEqual(1);

        context("with the multiple attribute set to false", () => {
          it("does not create a multiselect", () => {
            scope.multiple = "false";
            const {element} = SpecHelpers.compileDirective('    <th-autocomplete delegate="dg" multiple="true"></th-autocomplete>', scope);
            expect(element.find(".k-multiselect").length).toEqual(0);
          });
        });
      });
    });

    context("with the placeholder attribute set", () => {
      it("creates an autocomplete with a placeholder", () => {
        scope.placeholder = "Type a foo...";
        const {element} = SpecHelpers.compileDirective('<th-autocomplete delegate="dg" placeholder="{{placeholder}}"></th-autocomplete>', scope);
        expect(element.attr("placeholder")).toEqual("Type a foo...");
      });
    });

    context("with the group-by attribute set", () => {
      it("creates an autocomplete with grouped options", () => {
        scope.groupBy = "company";
        const {element} = SpecHelpers.compileDirective('<th-autocomplete delegate="dg" group-by="{{groupBy}}"></th-autocomplete>', scope);
        expect(element.attr("group-by")).toEqual("company");
      });
    });

    context("with the show-search-hint attribute set", () => {
      it("creates an autocomplete with a search hint", () => {
        scope.showSearchHint = "true";
        const {element} = SpecHelpers.compileDirective('<th-autocomplete delegate="dg" show-search-hint="{{showSearchHint}}"></th-autocomplete>', scope);
        expect(element.attr("show-search-hint")).toEqual("true");
      });
    });

    context("with the name attribute set", () => {
      it("creates an autocomplete with a name", () => {
        scope.name = "foo";
        const {element} = SpecHelpers.compileDirective('<th-autocomplete delegate="dg" name="{{name}}"></th-autocomplete>', scope);
        expect(element.attr("name")).toEqual("foo");
      });
    });

    context("with the condensed attribute set", () => {
      it("creates an autocomplete with condensed styling when set to true", () => {
        scope.condensed = "true";
        const {element} = SpecHelpers.compileDirective('<th-autocomplete delegate="dg" condensed="{{condensed}}"></th-autocomplete>', scope);
        expect(element.attr("condensed")).toEqual("true");
      });

      it("creates an autocomplete with no condensed attribute when condensed is non-truthy", () => {
        scope.condensed = "false";
        const {element} = SpecHelpers.compileDirective('<th-autocomplete delegate="dg" condensed="{{condensed}}"></th-autocomplete>', scope);
        expect(element.attr("condensed")).toEqual("false");
      });
    });


  });
});
