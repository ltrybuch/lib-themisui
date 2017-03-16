import * as moment from "moment";
import * as angular from "angular";

angular.module("thDatePickerDemo").controller("thDatePickerDemoCtrl5", function () {

  this.onchangeA = (newVal: moment.Moment) => {
    this.dateA = newVal;
  };
  this.onchangeB = (newVal: moment.Moment) => {
    this.dateB = newVal;
  };

  this.validatorObj = {
    messages: {
      required: "THIS IS ABSOLUTELY REQUIRED",
      valid: "NO WAY IS THIS VALID"
    }
  };

  this.submit = () => {
    if (this.form.$valid) {
      this.response = {$valid: this.form.$valid};
    } else {
      this.response = {
        $error: {
          dateA: this.form.dateA.$error,
          dateB: this.form.dateB.$error
        }
      };
    }
  };

});
