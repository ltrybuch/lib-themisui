import * as angular from "angular";
import "angular-mocks";
const SpecHelpers: any = require("spec_helpers");
let $componentController: angular.IComponentControllerService;

/* tslint:disable:no-shadowed-variable */

describe("ThemisComponents: thPopover : PopoverController", () => {
  const basicTemplate = `<th-popover template="'foo'">
                          <a class="trigger" style="margin-right: 30px;"></a>
                        </th-popover>`;
  const rightTemplate = `<th-popover template="'foo'" side="right">
                          <a class="trigger" style="margin-right: 30px;"></a>
                        </th-popover>`;
  const invalidTemplate = "<th-popover></th-popover>";

  beforeEach(angular.mock.module("ThemisComponents"));

  beforeEach(inject((
    _$componentController_: angular.IComponentControllerService,
  ) => {
    $componentController = _$componentController_;
  }));

  describe("Validations", () => {
    it("should throw an error when template is missing ", () => {
      expect(function() {
        SpecHelpers.compileDirective(invalidTemplate);
      }).toThrow(new Error(`thPopover: You must provide the "template" parameter.`));
    });
  });

  let scope: any = {};
  let popoverController: any;

  beforeEach(() => {
    const {element} = SpecHelpers.compileDirective(basicTemplate, scope);
    const locals = { $element: element };
    popoverController = $componentController("thPopover", locals);
    popoverController.$postLink();
  });

  it("creates a popover", () => {
    expect(popoverController.$element.find(".popover-container").length).toEqual(1);
  });

  describe("#showPopover:", () => {
    describe("with a left-aligned popover:", () => {
      it("don't apply the right-alignment class", () => {
        popoverController.$element.find(".trigger").triggerHandler("click");
        popoverController.showPopover();

        expect(popoverController.$element.find(".right-aligned-container").length).toEqual(0);
      });
    });

    describe("with a right-aligned popover:", () => {
      it("applies the expected margins and right-alignment class", () => {
        const {element} = SpecHelpers.compileDirective(rightTemplate, scope);
        const locals = { $element: element };
        popoverController = $componentController("thPopover", locals);
        popoverController.$postLink();
        popoverController.$element.find(".trigger").triggerHandler("click");
        popoverController.showPopover();

        expect(popoverController.$element.find(".right-aligned-container").length).toEqual(1);
        expect(popoverController.$element.find(".k-popup").css("margin-left")).toEqual("20px");
        expect(popoverController.$element.find(".k-popup").css("margin-right")).toEqual("30px");
      });
    });
  });

  describe("#hidePopover:", () => {
    it("calls hide() on the tooltip", () => {
      spyOn(popoverController.tooltipContainer, "hide");
      let tooltipContainerHideSpy = popoverController.tooltipContainer.hide as jasmine.Spy;
      popoverController.hidePopover();

      expect(tooltipContainerHideSpy).toHaveBeenCalled();
    });
  });

  describe("#calculateSize:", () => {
    it("calcultes the max-width and max-height attributes", () => {
      expect(popoverController.calculateSize(popoverController.popupElement)).toEqual({
        maxWidth: 380,
        maxHeight: 280,
      });
    });
  });

  describe("#resizePopup:", () => {
    it("add max-width and max-height attributes", () => {
      popoverController.$element.find(".trigger").triggerHandler("click");
      popoverController.showPopover();
      popoverController.resizePopup(popoverController.popupElement);

      expect(popoverController.$element.find(".k-animation-container").css("max-width")).toEqual("380px");
      expect(popoverController.$element.find(".k-animation-container .k-popup").css("max-height")).toEqual("280px");
    });
  });

  describe("#resizePopupHandler:", () => {

    it("calls the resizePopup() function", () => {
      spyOn(popoverController, "resizePopup");
      let resizePopupSpy = popoverController.resizePopup as jasmine.Spy;
      popoverController.$element.find(".trigger").triggerHandler("click");
      popoverController.resizePopupHandler();

      expect(resizePopupSpy).toHaveBeenCalled();
    });
  });

  describe("#togglePopover:", () => {
    describe("when toggled initially:", () => {
      it("is shown and the popover-content container is populated", () => {
        spyOn(popoverController, "resizePopupHandler");
        let resizePopupHandlerSpy = popoverController.resizePopupHandler as jasmine.Spy;

        expect(popoverController.$element.find(".popover-content").html()).toBe("");
        popoverController.togglePopover();

        expect(resizePopupHandlerSpy).toHaveBeenCalled();
        expect(popoverController.$element.find(".popover-content").html()).not.toBe("");
        expect(popoverController.$element.find(".k-tooltip-content").html()).toEqual("foo");

        describe("when toggled to hide:", () => {

          it("calls hide() on the tooltip", () => {
            spyOn(popoverController.tooltipContainer, "hide");
            let tooltipContainerHideSpy = popoverController.tooltipContainer.hide as jasmine.Spy;
            popoverController.togglePopover();

            expect(tooltipContainerHideSpy).toHaveBeenCalled();
          });
        });

        describe("when toggled to show:", () => {

          it("calls show() on the tooltip", () => {
            spyOn(popoverController.tooltipContainer, "show");
            let tooltipContainerShowSpy = popoverController.tooltipContainer.show as jasmine.Spy;
            popoverController.togglePopover();

            expect(tooltipContainerShowSpy).toHaveBeenCalled();
          });
        });
      });
    });

  });
});
