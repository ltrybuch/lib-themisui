import * as angular from "angular";
import { bootstrapCssClasses } from "../thGrid.cssClasses";

let SpecHelpers: any = require("spec_helpers.coffee");
const cssClasses = bootstrapCssClasses;

describe("ThemisComponents: Component: Row", () => {

  beforeEach(angular.mock.module("ThemisComponents"));

  it("adds the default classes when no options are provided", () => {
    const template = `<th-row></th-row>`;
    const { element } = SpecHelpers.compileDirective(template);

    expect(element.attr("class")).toContain(cssClasses.row.row);
    expect(element.attr("class")).toContain(cssClasses.row.alignment.centre);
  });

  it("can be setup to have no gutters", () => {
    const template = `<th-row hide-gutters="true"></th-row>`;
    const { element } = SpecHelpers.compileDirective(template);

    expect(element.attr("class")).toContain(cssClasses.row.noGutters);
  });

  describe("Alignment options", () => {
    it("can be aligned left", () => {
      const template = `<th-row align="left"></th-row>`;
      const { element } = SpecHelpers.compileDirective(template);

      expect(element.attr("class")).toContain(cssClasses.row.alignment.left);
    });

    it("can be aligned right", () => {
      const template = `<th-row align="right"></th-row>`;
      const { element } = SpecHelpers.compileDirective(template);

      expect(element.attr("class")).toContain(cssClasses.row.alignment.right);
    });

    it("can be aligned vertically", () => {
      const template = `<th-row align="vcentre"></th-row>`;
      const { element } = SpecHelpers.compileDirective(template);

      expect(element.attr("class")).toContain(cssClasses.row.alignment.vcentre);
    });
  });
});
