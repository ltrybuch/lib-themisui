import * as $ from "jquery";
import * as moment from "moment";
import * as angular from "angular";
import { ValidatorService } from "../services/validator.service";
import { DatepickerService } from "./thDatePicker.service";

class DatepickerController {
  /*@ngInject*/

  private name: string;
  private value: any; // for processing ng-model="" values passed in from parent scope
  private ngModel: moment.Moment;
  private min: moment.Moment;
  private max: moment.Moment;
  private onChange: (newVal: moment.Moment) => void;
  private ngDisabled: boolean;
  private dateFormat: string;
  private placeholder: string;
  private condensed: string;
  private datepicker: kendo.ui.DatePicker;
  private validator: kendo.ui.Validator;
  private customValidator: kendo.ui.ValidatorOptions;
  private inputElement: JQuery;
  private ngModelCtrl: angular.INgModelController;
  private formCtrl: angular.IFormController;
  private lastValidDate: moment.Moment;
  private revertToValid: boolean;
  private neverValidated = true; // for detecting the first change of formCtrl.$submitted

  constructor(
    private $scope: angular.IScope,
    private $element: angular.IAugmentedJQuery,
    private $attrs: angular.IAttributes,
    private DatepickerService: DatepickerService,
    private ValidatorService: ValidatorService,
    private thDefaults: any) {

    const oriDateFormat = this.dateFormat || this.thDefaults.get("dateFormat") || "yyyy-mm-dd";
    this.dateFormat = oriDateFormat.replace(/Y/g, "y").replace(/m/g, "M").replace(/D/g, "d");
  }

  private normalizeDate(date: moment.Moment, info: string) {
    if (moment.isMoment(date)) {
      return date.toDate();
    } else if (typeof date !== "undefined" && date !== null) {
      throw Error("The value passed into thDatePicker should be a moment object: " + info);
    }
  }

  private createDatepicker() {
    this.datepicker = this.DatepickerService.create({
      element: this.inputElement[0],
      dateFormat: this.dateFormat,
      min: this.normalizeDate(this.min, "min"),
      max: this.normalizeDate(this.max, "max"),
      name: this.name,
      value: this.value,
      ngDisabled: this.ngDisabled,
      change: (newVal: any) => {
        if (newVal !== null) {
          newVal = moment(newVal);
          this.lastValidDate = newVal;
        }

        if (typeof this.onChange === "function") {
          this.$scope.$apply(() => {
            this.onChange(newVal);
          });
        }
      },
      close: () => { // manually set touched because <input> blurs don't trigger here
        if (this.ngModelCtrl.$untouched) {
          this.$scope.$apply(() => {
            this.ngModelCtrl.$setTouched();
          });
        }
        this.validator.validateInput(this.inputElement);
      }
    });
  }

  private createValidator() {
    this.validator = this.ValidatorService.create({
      element: this.inputElement[0],
      attrs: this.$attrs,
      customOptions: this.customValidator,
      rules: {
        valid: (ele: any) => {
          const inputValue = ele[0].value;
          const modelValue = this.ngModel;
          const inputValueIsEmpty = inputValue === "";
          const ngModelIsValidMoment = modelValue && modelValue.isValid();
          const inputIsValid = inputValueIsEmpty || ngModelIsValidMoment;

          if (inputIsValid) {
            if (inputValueIsEmpty && this.revertToValid) {
              this.revertToLastValidDate();
            }
            return true;
          }

          if (this.revertToValid) {
            this.revertToLastValidDate();
            return true;
          }

          return false;
        }
      },
      messages: {
        valid: "Not a valid date"
      },
      validateInput: (e: any) => {
        // watch validity change and apply component class change, since other than ngRequire validators aren't part of ngModelCtrl
        this.ngModelCtrl.$setValidity(this.name, e.valid);

        // if the validation request comes from formCtrl, $apply is already taken care of by angular.
        if (this.neverValidated && this.formCtrl && this.formCtrl.$submitted) {
          this.neverValidated = false;
        } else {
          this.$scope.$apply();
        }
      }
    });
  }

  private revertToLastValidDate() {
    this.lastValidDate = this.lastValidDate || moment();
    this.datepicker.value(this.lastValidDate.toDate());
  }

  $onInit() {
    this.inputElement = $(this.$element[0]).find("input");
  }

  $postLink() {
    this.createDatepicker();
    this.createValidator();

    this.inputElement.attr("name", this.name);
    this.inputElement.attr("condensed", this.condensed);
    this.inputElement.attr("placeholder", (this.placeholder || this.dateFormat.toLowerCase()));

    // click input box toggle date picker
    this.inputElement.on("click", () => this.datepicker.open());
  }

  $doCheck() {
    // because form submit doesn't have event, and we can't $watch it from component:
    // trigger validation when form submits without touching input, for one time only.
    if (this.neverValidated && this.formCtrl && this.formCtrl.$submitted) {
      this.validator.validateInput(this.inputElement);
    }
  }

  $onChanges(changesObj: any) {
    if (!this.datepicker) { // return if datepicker is not init yet
      if (changesObj.ngModel) { // if init value is passed in from ng-model="", evaluate here for initializing datepicker later
        this.value = this.normalizeDate(changesObj.ngModel.currentValue, "ng-model");
      }
      return;
    }

    if (changesObj.ngModel) {
      const valuePassedIn = changesObj.ngModel.currentValue;
      const kendoValidDate = this.normalizeDate(valuePassedIn, "kendo value");
      this.datepicker.value(kendoValidDate);
    }

    if (changesObj.min) {
      this.datepicker.min(changesObj.min.currentValue);
    }

    if (changesObj.max) {
      this.datepicker.max(changesObj.max.currentValue);
    }

    if (changesObj.ngDisabled) {
      this.datepicker.enable(!changesObj.ngDisabled.currentValue);
    }

    if (changesObj.condensed) {
      this.inputElement.attr("condensed", this.condensed);
    }
  }

  $onDestroy() {
    this.inputElement.off("click");
  }
};

angular.module("ThemisComponents").component("thDatePicker", {
  template: "<input />",
  require: {
    ngModelCtrl: "ngModel",
    formCtrl: "?^^form"
  },
  bindings: {
    name: "@?",
    min: "<?",
    max: "<?",
    ngModel: "<",
    onChange: "<?",
    ngDisabled: "<?", // ng-required is not necessary here since class/attr change is dealt with on this ngModel level, and not passed to kendo
    placeholder: "@?",
    dateFormat: "@?",
    condensed: "@?",
    revertToValid: "<?",
    customValidator: "<?"
  },
  controller: DatepickerController
});
