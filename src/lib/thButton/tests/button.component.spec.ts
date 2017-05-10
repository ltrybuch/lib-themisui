import * as angular from "angular";
import "angular-mocks";
const SpecHelpers: any = require("spec_helpers");

/* tslint:disable:no-shadowed-variable */

describe("ThemisComponents: thButton : ButtonController", () => {
  const validTemplate = `<th-button type="create" ng-click="action()">some text</th-button>`;
  const templateWithHref = `<th-button href="#" type="secondary">some text</th-button>`;
  const disabledTemplate = `<th-button ng-click="action()" disabled>some text</th-button>`;
  const submitTemplate = `<th-button type="submit">Foo</th-button>`;
  const menuTemplate = `<th-button menu menu-template="'foo'">some text</th-button>`;
  const templateWithAriaLabel = `<th-button aria-label="test">text</th-button>`;
  const templateWithAriaDescribedBy = `<th-button aria-describedby="test-id">text</th-button>`;

  beforeEach(angular.mock.module("ThemisComponents"));

  describe("Creation", () => {

    it("creates a button", () => {
      const {element} = SpecHelpers.compileDirective(validTemplate);
      expect(element.find(".th-button").length).toEqual(1);

      it("has type 'button'", () => {
        expect(element.attr("type")).toBe("button");
      });

      it("creates the correct DOM element", () => {
        const buttonElement = element.find("button");
        expect(buttonElement).toBeDefined();
      });

      it("has class 'create'", () => {
        expect(element.hasClass("create")).toBe(true);
      });
    });

    describe("and the button is disabled", () => {
      it("has the disabled attribute", () => {
        const {element} = SpecHelpers.compileDirective(disabledTemplate);
        expect(element[0].hasAttribute("disabled")).toBe(true);
      });
    });

    describe("is a submit button", () => {
      it("has type of submit", () => {
        const {element} = SpecHelpers.compileDirective(submitTemplate);
        expect(element.find("button").attr("type")).toBe("submit");
      });
    });

    describe("with href attribute", () => {
      it("is an anchor tag", () => {
        const {element} = SpecHelpers.compileDirective(templateWithHref);
        expect(element.find(".th-button")[0].tagName).toEqual("A");

        it("has class 'secondary'", () => {
          expect(element.hasClass("secondary")).toBe(true);
        });
      });
    });

    describe("with menu attribute", () => {
      it("creates a menu button", () => {
        const {element} = SpecHelpers.compileDirective(menuTemplate);
        expect(element.find(".popover-container").length).toEqual(1);
      });
    });

    describe("with loading attribute", () => {
      let element: any;
      let scope: any;

      beforeEach(() => {
        let loading = true;
        let loadingTemplate = `<th-button loading="${loading}">text</th-button>`;
        let compiledComponent = SpecHelpers.compileDirective(loadingTemplate);
        element = compiledComponent.element;
        scope = compiledComponent.scope;
      });

      describe("when loading is true", () => {
        it("should set the loading indicator to visible", () => {
          const textElement = element.find("ng-transclude");

          // setDisabled() debounces with a timeout of 100ms
          setTimeout(() => {
            expect(textElement.hasClass("hide")).toBe(true);
            expect(element.find("button")[0].hasAttribute("disabled")).toBe(true);
          }, 100);
        });
      });

      describe("when loading is false", () => {
        it("should set the transcluded content to visible", () => {
          let loaderElement = element.find(".load-wrapper");
          const textElement = element.find("ng-transclude");

          expect(loaderElement.length).toBe(1);
          expect(textElement.hasClass("hide")).toBe(true);

          scope.$$childTail.button.loading = false;
          scope.$apply();

          // setDisabled() debounces with a timeout of 100ms
          setTimeout(() => {
            loaderElement = element.find(".load-wrapper");
            expect(loaderElement.length).toBe(0);
            expect(textElement.hasClass("show")).toBe(true);
            expect(element[0].hasAttribute("disabled")).toBe(false);
          }, 100);
        });
      });

      describe("with an aria-label attribute", () => {
        it("it is included in the element'", () => {
          const {element} = SpecHelpers.compileDirective(templateWithAriaLabel);
          expect(element.find("button").attr("aria-label")).toBe("test");
        });
      });

      describe("with an aria-describedby attribute", () => {
        it("it is included in the element'", () => {
          const {element} = SpecHelpers.compileDirective(templateWithAriaDescribedBy);
          expect(element.find("button").attr("aria-describedby")).toBe("test-id");
        });
      });

    });
  });
});
