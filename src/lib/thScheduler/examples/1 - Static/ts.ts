import * as angular from "angular";
import { entries as fixtureEntries, date as fixtureDate } from "../../fixtures/entries";

angular.module("thSchedulerDemo")
  .controller("thSchedulerDemoCtrl1", function(SchedulerDataSource) {

    this.options = {
      dataSource: SchedulerDataSource.createDataSource({
        data: fixtureEntries
      }),
      date: new Date(fixtureDate)
    };
  });
