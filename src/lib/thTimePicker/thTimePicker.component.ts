import * as $ from "jquery";
import * as moment from "moment";
import * as angular from "angular";
import { ValidatorService } from "../services/validator.service";
import { TimePickerService } from "./thTimePicker.service";

class TimePickerController {
  private name: string;
  private value: any;
  private ngModel: moment.Moment;
  private min: moment.Moment;
  private max: moment.Moment;
  private format: string;
  private placeholder: string;
  private onChange: (newVal: moment.Moment) => void;
  private validator: kendo.ui.Validator;
  private customValidator: kendo.ui.ValidatorOptions;
  private inputElement: JQuery;
  private timePicker: kendo.ui.TimePicker;
  private ngModelCtrl: angular.INgModelController;
  private formCtrl: angular.IFormController;
  private neverValidated = true; // for detecting the first change of formCtrl.$submitted

  /*@ngInject*/
  constructor(
    private $scope: angular.IScope,
    private $element: angular.IAugmentedJQuery,
    private $attrs: angular.IAttributes,
    private TimePickerService: TimePickerService,
    private ValidatorService: ValidatorService,
  ) {
  }

  $onInit() {
    this.inputElement = $(this.$element[0]).find("input");
  }

  $postLink() {
    this.createTimePicker();
    this.createValidator();

    this.inputElement.attr("name", this.name);
    this.inputElement.attr("placeholder", this.placeholder);
  }

  private formIsSubmitted() {
    return this.formCtrl && this.formCtrl.$submitted;
  }

  $doCheck() {
    // because form submit doesn't have event, and we can't $watch it from component:
    // trigger validation when form submits without touching input, for one time only.
    if (this.neverValidated && this.formIsSubmitted()) {
      this.validator.validateInput(this.inputElement);
    }
  }

  $onChanges(changesObj: angular.IOnChangesObject) {
    if (!this.timePicker) {
      if (changesObj.ngModel) {
        this.value = this.normalizeTime(changesObj.ngModel.currentValue, "ng-model");
      }
      return;
    }

    if (changesObj.ngModel) {
      const kendoValidTime = this.normalizeTime(changesObj.ngModel.currentValue, "ng-model");
      this.timePicker.value(kendoValidTime);
    }

    if (changesObj.min) {
      const kendoValidTime = this.normalizeTime(changesObj.min.currentValue, "min");
      this.timePicker.min(kendoValidTime);
    }

    if (changesObj.max) {
      const kendoValidTime = this.normalizeTime(changesObj.max.currentValue, "max");
      this.timePicker.max(kendoValidTime);
    }
  }

  private normalizeTime(time: moment.Moment, info: string) {
    if (moment.isMoment(time)) {
      return time.toDate();
    } else if (typeof time === "undefined" || time === null) {
      return time;
    }
    throw Error("The value passed into thTimePicker should be a moment object: " + info);
  }

  private createTimePicker() {
    this.timePicker = this.TimePickerService.create({
      element: this.inputElement[0],
      min: this.normalizeTime(this.min, "min"),
      max: this.normalizeTime(this.max, "max"),
      format: this.format,
      value: this.value,
      change: (newVal: any) => {
        if (typeof this.onChange === "function") {
          this.$scope.$apply(() => {
            this.onChange(newVal ? moment(newVal) : newVal);
          });
        }
      },
      close: () => {
        this.validator.validateInput(this.inputElement);
      },
    });
  }

  private createValidator() {
    this.validator = this.ValidatorService.create({
      element: this.inputElement[0],
      attrs: this.$attrs,
      customOptions: this.customValidator,
      rules: {
        /**
         * http://www.telerik.com/forums/k-ng-model-required-w-angular-validation
         * http://www.telerik.com/forums/how-to-properly-validate-datetimepicker
         */
        valid: (ele: any) => {
          const inputValue = ele[0].value;
          const modelValue = this.ngModel;
          const inputValueIsEmpty = inputValue === "";
          const ngModelIsValidMoment = modelValue && modelValue.isValid();
          const inputIsValid = inputValueIsEmpty || ngModelIsValidMoment;

          if (inputIsValid) {
            return true;
          }

          return false;
        },
      },
      messages: {
        valid: "Not a valid time",
      },
      validateInput: (e: any) => {
        this.ngModelCtrl.$setValidity("kendo", e.valid);
        this.ngModelCtrl.$setTouched();

        // if the validation request comes from formCtrl, $apply is already taken care of by angular.
        if (this.neverValidated && this.formIsSubmitted()) {
          this.neverValidated = false;
        } else {
          this.$scope.$apply();
        }
      },
    });
  }

};

const TimePickerComponent: angular.IComponentOptions = {
  template: "<input />",
  require: {
    ngModelCtrl: "ngModel",
    formCtrl: "?^^form",
  },
  bindings: {
    name: "@?",
    min: "<?",
    max: "<?",
    format: "@?",
    ngModel: "<",
    onChange: "<?",
    placeholder: "@?",
    customValidator: "<?",
},
  controller: TimePickerController,
};

export { TimePickerController, TimePickerComponent };
