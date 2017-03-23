import * as angular from "angular";

angular.module("thSchedulerDemo")
  .controller("thSchedulerDemoCtrl2", function(SchedulerDataSource) {

    this.options = {
      dataSource: SchedulerDataSource.createDataSource({
        schema: {
          data: "data",
          model: {
            fields: {
              end: { from: "end_at", type: "date" },
              id: { from: "id", type: "number" },
              start: { from: "start_at", type: "date" },
              title: { from: "summary" },
            },
            id: "id",
          },
        },
        transport: {
          read: {
            dataType: "json",
            type: "get",
            url: "https://private-4521b-entries.apiary-mock.com/entries",
          },
        },
      }),
      // needed to set the range to the mocks from the server
      date: new Date("2017/02/20"),
    };
  });
