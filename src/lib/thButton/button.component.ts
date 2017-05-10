import * as angular from "angular";
import * as $ from "jquery";
const buttonTemplate = require("./button.template.html") as string;
const menuTemplate = require("./button.menu.template.html") as string;
const anchorTemplate = require("./button.anchor.template.html") as string;
import debounce = require("debounce");

class ButtonController {
  public type: string;
  public href: string;
  public menuSide: string;
  public menuTemplate: string;
  public loading: boolean;
  public ngDisabled: any;
  public ariaLabel: string;
  public ariaDescribedby: string;
  public theme: string;
  public buttonElement: any;
  public menuButtonElement: any;

  /* @ngInject */
  constructor(
    private $scope: angular.IScope,
    private $element: angular.IAugmentedJQuery,
    private $attrs: angular.IAttributes,

  ) {
    const types = ["standard", "create", "destroy"];
    this.type = this.type || "standard";
    this.theme = types.indexOf(this.type.toLowerCase()) !== -1 ? "light" : "dark";
    this.menuSide = this.menuSide || "left";
    this.ngDisabled = this.ngDisabled || false;
    this.loading = this.loading || false;
  }

  $postLink() {
    this.buttonElement = $(this.$element).find("button");
    this.menuButtonElement = $(this.$element).find(".menu-button");

    // In HTML5 a button with no type attribute is "submit" by default.
    // If not used for submit, must explicitly specify "button".
    const isSubmit = this.$attrs.submit !== undefined || this.$attrs.type === "submit";
    const type = isSubmit ? "submit" : "button";
    this.buttonElement.attr("type", type);

    if (this.$attrs.menu === "") {
      this.buttonElement.click(() => {
        this.menuButtonClickHandler();
      });
    }

    this.$scope.$watch("button.loading", (newValue) => {
      this.loadingHandler(newValue);
    });
  }

  private menuButtonClickHandler() {
    const tooltipElement = $(this.$element).find(".tooltip-object").data("kendoTooltip");

    tooltipElement.bind("show", () => {
      this.togglePopupClass(true);
    });

    tooltipElement.bind("hide", () => {
      this.togglePopupClass(false);
    });
  }

  private loadingHandler(loadingStatus: any) {
    if (loadingStatus === false) {
      if (this.$attrs.disabled === "" || this.$attrs.disabled === true) {
        this.setDisabled();
      } else {
        this.setEnabled();
      }
    } else {
      this.setDisabled();
    }
  }

  private togglePopupClass(visible: boolean) {
    if (visible) {
      this.menuButtonElement.addClass("pressed");
    } else {
      this.menuButtonElement.removeClass("pressed");
    }
  }

  public setDisabled() {
    const addDisabledProp = debounce(() => {
      this.buttonElement.prop("disabled", true);
    }, 100);
    addDisabledProp();
  }

  private setEnabled() {
    this.buttonElement.prop("disabled", false);
  }
}


const ButtonComponent: angular.IComponentOptions = {
  template: ["$attrs", ($attrs: angular.IAttributes) => {
    if ($attrs.hasOwnProperty("href")) {
      return anchorTemplate;
    } else if ($attrs.hasOwnProperty("menu")) {
      return menuTemplate;
    } else {
      return buttonTemplate;
    }
  }],
  controller: ButtonController,
  controllerAs: "button",
  bindings: {
    type: "@",
    href: "@",
    menuSide: "@",
    menuTemplate: "<",
    loading: "=?",
    ngDisabled: "=?",
    ariaLabel: "@",
    ariaDescribedby: "@",
  },
  transclude: true,
};

export default ButtonComponent;
