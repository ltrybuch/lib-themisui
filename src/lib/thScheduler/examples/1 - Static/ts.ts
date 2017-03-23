import * as angular from "angular";
import * as expectedEntries from "../../tests/fixtures/entries";

angular.module("thSchedulerDemo")
  .controller("thSchedulerDemoCtrl1", function(SchedulerDataSource) {

    this.options = {
      dataSource: SchedulerDataSource.createDataSource({
        data: expectedEntries.items,
      }),
      date: new Date(expectedEntries.date),
    };

});
