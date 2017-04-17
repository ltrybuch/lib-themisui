import * as angular from "angular";
import AutocompleteFactory from "./autocomplete.factory";
import AutocompleteAbstract from "./providers/autocomplete.abstract";
import { AutocompleteDataOptions, AutocompleteType } from "./providers/autocomplete.interface";
import { AutocompleteComponentError } from "./autocomplete.errors";
import { ValidatorService } from "../services/validator.service";

class AutocompleteController {
  private options: AutocompleteDataOptions;
  private name: string;
  private placeholder: string;
  private ngModel: any;
  private ngModelCtrl: angular.INgModelController;
  private formCtrl: angular.IFormController;
  private ngDisabled: boolean;
  private componentType: AutocompleteType;
  private validator: kendo.ui.Validator;
  private customValidator: kendo.ui.ValidatorOptions;
  private neverValidated = true;
  private $inputElement: JQuery;

  private onChange: (newVal: any) => void;
  private autoComplete: AutocompleteAbstract;

  /* @ngInject */
  constructor(
    private $scope: angular.IScope,
    private $element: angular.IAugmentedJQuery,
    public $timeout: angular.ITimeoutService,
    private $attrs: angular.IAttributes,
    private ValidatorService: ValidatorService,
  ) {}

  $onInit() {
    this.$inputElement = $(this.$element).find("input, select");

    this.validateArgs();
    this.setComponentType();
    this.watchNgModelValueChange();
  }

  $postLink() {
    this.createAutocomplete();
    this.createValidator();

    this.$element.find("input").on("blur", () => {
      this.$scope.$apply(() => this.ngModelCtrl.$setTouched());
    });
  }


  $onChanges(change: angular.IOnChangesObject) {
    this.$timeout(() => {
      // FIXME: this previousValue is not undefined check is here because of $timeout
      // inside $onChanges. Will be fixed with the one-way bind ticket: CLIO-45324
      if (change.ngDisabled && typeof change.ngDisabled.previousValue === "boolean") {
        this.autoComplete.toggleEnabled();
      }

      if (change.ngRequired && typeof change.ngRequired.previousValue === "boolean") {
        if (change.ngRequired.currentValue === true) {
          this.ngModelCtrl.$setUntouched();
        } else {
          this.validator.validateInput(this.$inputElement[0]);
        }
      }

      // FIXME: This code has been disabled due to not working.
      // Re-enable with ticket CLIO-45890
      // if (change.showSearchHint && typeof change.showSearchHint.previousValue === "boolean") {
      //   this.autoComplete.toggleSearchHint(change.showSearchHint.currentValue);
      // }
    });
  }

  $doCheck() {
    // because form submit doesn't have event, and we can't $watch it from component:
    // trigger validation when form submits without touching input, for one time only.
    if (this.neverValidated && this.formIsSubmitted()) {
      this.validator.validateInput(this.$inputElement[0]);
    }
  }

  $onDestroy() {
    this.$element.find("input").off("blur");
  }

  private createAutocomplete() {
    this.autoComplete = AutocompleteFactory.createAutocomplete(this.componentType, {
      element: this.$inputElement[0],
      options: this.options,
      placeholder: this.placeholder,
      value: this.ngModel,
      ngDisabled: this.ngDisabled,
      change: (newValue: any) => {
        this.$scope.$apply(() => {
          this.ngModel = newValue;
        });
        if (this.onChange) {
          this.onChange(newValue);
        }
      },
      close: () => {
        if (this.ngModelCtrl.$untouched) {
          this.$scope.$apply(() => {
            this.ngModelCtrl.$setTouched();
          });
        }
        this.validator.validateInput(this.$inputElement[0]);
      },
    });
  }

  private createValidator() {
    this.validator = this.ValidatorService.create({
      element: this.$inputElement[0],
      attrs: this.$attrs,
      customOptions: this.customValidator,
      validateInput: (e: kendo.ui.ValidatorValidateEvent) => {
        this.ngModelCtrl.$setValidity(this.name, e.valid);

        // if the validation request comes from formCtrl, $apply is already taken care of by angular.
        if (this.neverValidated && this.formIsSubmitted()) {
          this.neverValidated = false;
        } else {
          this.$scope.$apply();
        }
      },
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

  private formIsSubmitted() {
    return this.formCtrl && this.formCtrl.$submitted;
  }

  private watchNgModelValueChange() {
    this.$scope.$watch(() => {
      return this.ngModel;
    }, (newModel) => {
      // Wait for the current digest cycle to end before triggering the update
      this.$timeout(() => {
        this.autoComplete.setValue(newModel);
      });
    });
  }
}

const AutocompleteComponent: angular.IComponentOptions = {
  template: ["$attrs", ($attrs: angular.IAttributes) => {
    return $attrs.hasOwnProperty("multiple") ? `<select></select>` : `<input />`;
  }],
  require: {
    ngModelCtrl: "?ngModel",
    formCtrl: "?^^form",
  },
  bindings: {
    name: "@?",
    ngModel: "=?",
    options: "<",
    onChange: "<?",
    ngDisabled: "<?",
    ngRequired: "<?",
    placeholder: "@?",
    customValidator: "<?",
  },
  controller: AutocompleteController,
};

export default AutocompleteComponent;
