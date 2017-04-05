import * as angular from "angular";
import AutocompleteFactory from "./autocomplete.factory";
import AutocompleteAbstract from "./providers/autocomplete.abstract";
import { AutocompleteDataOptions, AutocompleteType } from "./providers/autocomplete.interface";
import { AutocompleteComponentError } from "./autocomplete.errors";

class AutocompleteController {
  private options: AutocompleteDataOptions;
  private name: string;
  private placeholder: string;
  private ngModel: any;
  private ngDisabled: any;
  private ngRequired: any;
  private componentType: AutocompleteType;
  private validationNameAttr: string;

  private onChange: (newVal: any) => void;
  private autoComplete: AutocompleteAbstract;

  /* @ngInject */
  constructor(
    private $scope: angular.IScope,
    private $element: angular.IAugmentedJQuery,
    public $timeout: angular.ITimeoutService,
    private $attrs: angular.IAttributes,
  ) {
    $scope.$watch(() => {
      return this.ngModel;
    }, (newModel) => {
      // Wait for the current digest cycle to end before triggering the update
      $timeout(() => {
        this.autoComplete.setValue(newModel);
      });
    });
  }

  private validateArgs() {
    if (this.options === null || typeof this.options === "undefined") {
      throw new AutocompleteComponentError(`You must provide the "options" parameter.`);
    }

    if ("multiple" in this.$attrs && "combobox" in this.$attrs) {
      throw new AutocompleteComponentError(`multiple and combobox are mutually exclusive`);
    }
  }

  private setComponentType() {
    this.componentType = "autocomplete";

    if ("multiple" in this.$attrs) {
      this.componentType = "multiple";
    } else if ("combobox" in this.$attrs) {
      this.componentType = "combobox";
    }
  }

  $onChanges(change: any) {
    this.$timeout(() => {
      if (change.ngDisabled && typeof change.ngDisabled.previousValue === "boolean") {
        this.autoComplete.toggleEnabled();
      }
      // FIXME: This code has been disabled due to not working.
      // Re-enable with ticket CLIO-45890
      // if (change.showSearchHint && typeof change.showSearchHint.previousValue === "boolean") {
      //   this.autoComplete.toggleSearchHint(change.showSearchHint.currentValue);
      // }
      if (change.ngRequired && typeof change.ngRequired.previousValue === "boolean") {
        this.autoComplete.toggleRequired();
      }
    });
  }

  $onInit() {
    this.validateArgs();
    this.setComponentType();
  }

  $postLink() {
    const elementType = this.componentType === "multiple" ? "select" : "input";
    const $childElement = angular.element(this.$element).find(`${elementType}:first`);

    if (this.name) {
      this.$element.removeAttr("name");
    }

    this.autoComplete = AutocompleteFactory.createAutocomplete(this.componentType, {
      element: $childElement[0],
      options: this.options,
      placeholder: this.placeholder,
      value: this.ngModel,
      ngDisabled: this.ngDisabled,
      ngRequired: this.ngRequired,
      change: (newValue: any) => {
        this.$scope.$apply(() => {
          this.ngModel = newValue;
        });
        if (this.onChange) {
          this.onChange(newValue);
        }
      },
    });

    this.validationNameAttr = `validation-${this.name}`;

    if (this.$attrs.required) {
      // Add error element
      angular.element(this.$element)
        .append(`<span class='k-invalid-msg' data-for="${this.validationNameAttr}"></span>`);

      // Add required attributes
      $childElement.attr("required", "required");
      $childElement.attr("data-required-msg", "This field is required.");
    }
  }
}

const AutocompleteComponent: angular.IComponentOptions = {
  template: ["$attrs", function ($attrs: any) {
      let templateString = "";
      if ("multiple" in $attrs) {
        templateString = "<select name='{{$ctrl.validationNameAttr}}'></select>";
      } else {
        templateString = `
          <input name="{{$ctrl.validationNameAttr}}" />
          <input type="hidden" name="{{$ctrl.name}}" ng-value="$ctrl.ngModel.id" />
      `;
      }
      return templateString;
    }],
    bindings: {
      ngModel: "=?",
      placeholder: "@",
      name: "@?",
      ngDisabled: "<?",
      ngRequired: "<?",
      options: "=",
      onChange: "<?",
    },
    controller: AutocompleteController,
};

export default AutocompleteComponent;
