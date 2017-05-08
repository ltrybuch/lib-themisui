import * as moment from "moment";
import * as angular from "angular";

angular.module("thTimePickerDemo").controller("thTimePickerDemoCtrl1", function() {
  this.time = moment();

  this.onChange = (newVal: moment.Moment) => this.time = newVal;

  this.decrementTime = () => {
    if (this.time) {
      this.time = this.time.clone().subtract(1, "minutes");
    }
  };

  this.incrementTime = () => {
    if (this.time) {
      this.time = this.time.clone().add(1, "minutes");
    }
  };
});
