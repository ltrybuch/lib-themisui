import * as moment from "moment";
import * as angular from "angular";

angular.module("thDatePickerDemo").controller("thDatePickerDemoCtrl3", function () {
  this.date = moment("2016-01-12");

  this.onchange = (newVal: moment.Moment) => {
    this.date = newVal;
  };
});
