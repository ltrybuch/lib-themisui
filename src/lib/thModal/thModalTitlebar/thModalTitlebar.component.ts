import * as angular from "angular";

const template = require("./thModalTitlebar.template.html") as string;

class ModalTitlebar {
  private type: "standard" | "destroy";
  private showCloseButton: boolean;
  private beforeClosePromise: () => Promise<void>;

  /* @ngInject */
  constructor(
    private $element: angular.IAugmentedJQuery,
    private $scope: angular.IScope,
    private $q: angular.IQService,
  ) {}

  $onInit() {
    if (typeof this.type === "undefined") {
      this.type = "standard";
    }
    if (typeof this.showCloseButton === "undefined") {
      this.showCloseButton = true;
    }
  };

  $postLink() {
    this.$element.addClass(`type-${this.type}`);
  }

  close() {
    const beforeClosePromise = this.beforeClosePromise || this.$q.resolve;
    return beforeClosePromise().then(() => {
      if (this.$scope.$parent.modal) {
        this.$scope.$parent.modal.dismiss();
      }
    });
  }
}

const ModalTitlebarComponent: angular.IComponentOptions = {
  template,
  controller: ModalTitlebar,
  bindings: {
    title: "@",
    type: "@",
    showCloseButton: "<",
    beforeClosePromise: "<?",
  },
};

export { ModalTitlebar, ModalTitlebarComponent };
