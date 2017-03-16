import * as moment from "moment";
import * as angular from "angular";

angular.module("thDatePickerDemo").controller("thDatePickerDemoCtrl4", function () {
  this.minDate = moment("2017-01-12");
  this.maxDate = moment("2017-01-12");

  this.onchange = (newVal: moment.Moment) => {
    this.date = newVal;
  };
});
