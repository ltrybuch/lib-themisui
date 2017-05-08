import * as moment from "moment";
import * as angular from "angular";

angular.module("thTimePickerDemo").controller("thTimePickerDemoCtrl3", function() {
  this.startTime = null;
  this.endTime = null;

  this.startRangeMin = moment("0", "hh");
  this.endRangeMin = this.startRangeMin.clone();
  this.startRangeMax = moment("23:30", "hh:mm");
  this.endRangeMax = this.startRangeMax.clone();

  this.onStartTimeChange = (newVal: moment.Moment) => {
    const lastStartTime = this.startTime;
    this.startTime = newVal;
    if (this.startTime) {
      this.endRangeMin = this.startTime.clone();
      this.endRangeMax = this.endRangeMin.clone().add(24, "hours");

      // Calculate previous time difference and update end time to reflect this.
      if (lastStartTime && this.endTime) {
        const diff = this.endTime.diff(lastStartTime, "minutes");
        this.endTime = this.startTime.clone().add(diff, "minutes");
      }
    }
  };

  this.onEndTimeChange = (newVal: moment.Moment) => {
    this.endTime = newVal;
  };
});
