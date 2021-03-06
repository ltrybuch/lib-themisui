import * as angular from "angular";
import * as $ from "jquery";
import debounce = require("debounce");
import "@progress/kendo-ui/js/kendo.tooltip.js";
const template = require("./popover.template.html") as string;

class PopoverController {
  private side: string;
  private template: string;
  private tooltipContainer: any;
  private anchorElement: any;
  private popupElement: any;

  tooltipOptions = {
    showOn: "click",
    autoHide: false,
  };

  popoverTemplateContent = this.template;

  /* @ngInject */
  constructor(
    private $element: angular.IAugmentedJQuery,
  ) {
    this.side = this.$element.attr("side") || "left";
  }

  $onInit() {
    this.validateArgs();
  }

  $onDestroy() {
    window.removeEventListener("resize", this.resizePopupHandler, false);
  }

  $postLink() {
    this.tooltipContainer = $(this.$element).find(".tooltip-object").data("kendoTooltip");
    this.anchorElement = $(this.$element).find(".anchor-container")[0].firstElementChild;

    window.addEventListener("resize", debounce(() => {
      this.resizePopupHandler();
    }, 100), false);

    this.tooltipContainer.bind("hide", (e: any) => {
      const popupElement = e.sender.popup.element[0];
      // Reset horizontal margins when popup is closed so Kendo doesn't include
      // it in the width calculation next time it's shown.
      $(popupElement).css({"margin-right": "0px", "margin-left": "0px"});
    });

    this.tooltipContainer.bind("show", () => {
      this.showPopover();
    });

    $(this.anchorElement).click(() => {
      this.togglePopover();
    });
  }

  private validateArgs() {
    if (this.template === null || typeof this.template === "undefined") {
      throw new Error(`thPopover: You must provide the "template" parameter.`);
    }
  }

  public showPopover() {
    this.popupElement = $(this.$element).find(".k-tooltip");
    // Match margin for popup to that of the anchor element.
    $(this.popupElement).css("margin-" + this.side, $(this.anchorElement).css("margin-" + this.side));

    // Add class to overwrite inline styles applied by Kendo.
    if (this.side === "right") {
      $(this.popupElement).css("margin-left", "20px");
      $(this.$element).find(".popover-content .k-animation-container").addClass("right-aligned-container");
    }
  }

  public hidePopover() {
    this.tooltipContainer.hide();
  }

  private togglePopover() {
    if (this.tooltipContainer.popup) {
      if (this.tooltipContainer.popup.visible()) {
        this.tooltipContainer.hide();
      } else {
        this.tooltipContainer.show($(this.anchorElement));
      }
    } else {
      // Trigger a resize event on initilization so that Kendo recalculates
      // the width of the popup.
      this.tooltipContainer.show($(this.anchorElement));
      this.resizePopupHandler();
    }

    const popupElement = this.tooltipContainer.popup.element[0];
    const popupKendoComponent = $(popupElement).data("kendoPopup");
    const popupContent = $(this.$element).find(".popover-content");

    popupKendoComponent.setOptions({
      appendTo: popupContent,
    });
    popupContent.append(popupElement.parentElement);
  }

  private calculateSize() {
    const marginSize = 20;
    const maxHeight =
      window.innerHeight - ($(this.anchorElement).offset().top + $(this.anchorElement).height() + marginSize);
    let maxWidth;

    if (this.side === "right") {
      maxWidth = $(this.anchorElement).offset().left + $(this.anchorElement).width();
    } else {
      maxWidth = window.innerWidth - ($(this.anchorElement).offset().left + marginSize);
    }

    return {maxWidth: maxWidth, maxHeight: maxHeight};
  }

  private resizePopup(popupElement: HTMLElement) {
    const popupDimensions = this.calculateSize();
    $(popupElement.parentElement).css("max-width", popupDimensions.maxWidth + "px");
    $(popupElement).css("max-height", popupDimensions.maxHeight + "px");
  }

  private resizePopupHandler() {
    if (this.tooltipContainer.popup) {
      this.resizePopup(this.tooltipContainer.popup.element[0]);
    }
  }
}


const PopoverComponent: angular.IComponentOptions = {
  template,
  controller: PopoverController,
  controllerAs: "popover",
  bindings: {
    side: "@",
    template: "<",
  },
  transclude: true,
};

export default PopoverComponent;
