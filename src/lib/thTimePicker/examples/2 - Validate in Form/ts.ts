import * as moment from "moment";
import * as angular from "angular";

angular.module("thTimePickerDemo").controller("thTimePickerDemoCtrl2", function() {
  this.time = null;

  this.onChange = (newVal: moment.Moment) => this.time = newVal;

  this.submit = () => {
    if (this.form.$valid) {
      this.response = {$valid: this.form.$valid};
    } else {
      this.response = {
        $error: {
          startTime: this.form.startTime.$error,
        },
      };
    }
  };
});
