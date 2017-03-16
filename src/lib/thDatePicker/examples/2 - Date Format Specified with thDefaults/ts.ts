import * as moment from "moment";
import * as angular from "angular";

angular.module("thDatePickerDemo").run(function (thDefaults: any) {
  thDefaults.set("dateFormat", "dd/mm/yyyy");
});

angular.module("thDatePickerDemo").controller("thDatePickerDemoCtrl2", function () {
  this.onchange = (newVal: moment.Moment) => {
    this.date = newVal;
  };
});
