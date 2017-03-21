import * as angular from "angular";
import { AutocompleteFactory } from "./autocomplete.factory";
import { AbstractAutocomplete } from "./providers/autocomplete.abstract";

export class AutocompleteController {
  private delegate: any;
  private name: string;
  private placeholder: string;
  private ngModel: any;
  private ngDisabled: any;
  private ngRequired: any;
  private combobox: boolean;
  private multiple: boolean;
  private groupBy: any;
  private condensed: any;
  private rowTemplate: string;
  private trackField: string;
  private validationNameAttr: string;
  private onChange: (newVal: any) => void;
  private autoComplete: AbstractAutocomplete;

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

  $onChanges(change: any) {
    this.$timeout(() => {
      if (change.ngDisabled && typeof change.ngDisabled.previousValue === "boolean") {
        this.autoComplete.toggleEnabled();
      }
      if (change.showSearchHint && typeof change.showSearchHint.previousValue === "boolean") {
        this.autoComplete.toggleSearchHint(change.showSearchHint.currentValue);
      }
      if (change.ngRequired && typeof change.ngRequired.previousValue === "boolean") {
        this.autoComplete.toggleRequired();
      }
    });
  }

  $postLink() {
    const elementType = this.multiple ? "select" : "input";
    const $childElement = angular.element(this.$element).find(`${elementType}:first`);
    const $parentElement = angular.element($childElement).parent();

    if (this.groupBy) {
      this.delegate.dataSource.group({field: this.groupBy});
    }

    if (this.name) {
      this.$element.removeAttr("name");
    }

    /**
     * If the condensed attr is supplied, it is already on the th-autocomplete attribute
     * so we need to remove it if non-truthy
     */
    if ("true" != this.condensed) {
      this.$element.removeAttr("condensed");
    }

    this.autoComplete = AutocompleteFactory.createAutocomplete({
      element: $childElement[0],
      parentElement: $parentElement,
      delegate: this.delegate,
      placeholder: this.placeholder,
      value: this.ngModel,
      ngDisabled: this.ngDisabled,
      ngRequired: this.ngRequired,
      combobox: this.combobox,
      multiple: this.multiple,
      rowTemplate: this.rowTemplate,
      change: (newValue: any) => {
        this.$scope.$apply(() => {
          this.ngModel = newValue;
        });
        if (this.onChange) {
          this.onChange(newValue);
        }
      }
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

    this.trackField = this.delegate.trackField ?
                      this.delegate.trackField : "id";
  }
}

angular.module("ThemisComponents")
  .component("thAutocomplete", {
    template: ["$attrs", function ($attrs: any) {
      let templateString = "";
      if ($attrs.multiple) {
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
      delegate: "=",
      ngModel: "=?",
      placeholder: "@",
      groupBy: "@",
      showSearchHint: "@?",
      multiple: "@",
      name: "@?",
      condensed: "@?",
      ngDisabled: "<?",
      ngRequired: "<?",
      combobox: "@",
      rowTemplate: "<?",
      onChange: "<?"
    },
    controller: AutocompleteController
  });
