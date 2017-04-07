import * as angular from "angular";
import { bootstrapCssClasses } from "../thGrid.cssClasses";

let SpecHelpers: any = require("spec_helpers.coffee");
const cssClasses = bootstrapCssClasses;

describe("ThemisComponents: Component: Column", () => {

  beforeEach(angular.mock.module("ThemisComponents"));

  describe("Error states", () => {
    it("needs to be the child of a thRow component", () => {
      const invalidTemplate = `<th-column columns="12"></th-column>`;

      expect( function(){ SpecHelpers.compileDirective(invalidTemplate); } ).toThrow();
    });
  });

  describe("Column options", () => {
    it("defaults to a flexbile column size with no options provided", () => {
      const template = `<th-row><th-column></th-column></th-row>`;
      const { element } = SpecHelpers.compileDirective(template);

      expect(element.children().attr("class")).toContain(cssClasses.column.column);
    });

    it("can have the number of columns provided", () => {
      const numberOfColumns = "6";
      const template = `<th-row><th-column columns="${numberOfColumns}"></th-column></th-row>`;
      const { element } = SpecHelpers.compileDirective(template);

      const expectedClass = cssClasses.column.columnsMd.replace("xx", numberOfColumns);
      expect(element.children().attr("class")).toContain(expectedClass);
    });

    it("can have the number of columns on small screens provided", () => {
      const numberOfColumns = "6";
      const template = `<th-row><th-column columns="12" columns-sm="${numberOfColumns}"></th-column></th-row>`;
      const { element } = SpecHelpers.compileDirective(template);

      const expectedClass = cssClasses.column.columnsSm.replace("xx", numberOfColumns);
      expect(element.children().attr("class")).toContain(expectedClass);
    });

    it("can have the number of columns on extra small screens provided", () => {
      const numberOfColumns = "6";
      const template = `<th-row><th-column columns="12" columns-xs="${numberOfColumns}"></th-column></th-row>`;
      const { element } = SpecHelpers.compileDirective(template);

      const expectedClass = cssClasses.column.columnsXs.replace("xx", numberOfColumns);
      expect(element.children().attr("class")).toContain(expectedClass);
    });

    it("can have the number of columns on large screens provided", () => {
      const numberOfColumns = "6";
      const template = `<th-row><th-column columns="12" columns-lg="${numberOfColumns}"></th-column></th-row>`;
      const { element } = SpecHelpers.compileDirective(template);

      const expectedClass = cssClasses.column.columnsLg.replace("xx", numberOfColumns);
      expect(element.children().attr("class")).toContain(expectedClass);
    });
  });

  describe("Display options", () => {
    it("can be hidden on small screens", () => {
      const template = `<th-row><th-column columns="12" hide-sm="true"></th-column></th-row>`;
      const { element } = SpecHelpers.compileDirective(template);

      expect(element.children().attr("class")).toContain(cssClasses.column.hideSm);
    });

    it("can be hidden on extra small screens", () => {
      const template = `<th-row><th-column columns="12" hide-xs="true"></th-column></th-row>`;
      const { element } = SpecHelpers.compileDirective(template);

      expect(element.children().attr("class")).toContain(cssClasses.column.hideXs);
    });

    it("can be hidden on medium screens", () => {
      const template = `<th-row><th-column columns="12" hide-md="true"></th-column></th-row>`;
      const { element } = SpecHelpers.compileDirective(template);

      expect(element.children().attr("class")).toContain(cssClasses.column.hideMd);
    });

    it("can be hidden on large screens", () => {
      const template = `<th-row><th-column columns="12" hide-lg="true"></th-column></th-row>`;
      const { element } = SpecHelpers.compileDirective(template);

      expect(element.children().attr("class")).toContain(cssClasses.column.hideLg);
    });
  });
});
