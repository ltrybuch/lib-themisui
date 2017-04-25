import * as angular from "angular";
import { remoteColumns } from "../../tests/fixtures/tabledata";

angular.module("thDataTableDemo")
  .controller("thDataTableDemoCtrl4", function(DataSource) {

    this.options = {
      columns: remoteColumns,
      resizable: true,
      dataSource: DataSource.createDataSource({
        transport: {
          read: {
            url: "https://api.github.com/search/repositories?q=vancouver&limit=25",
            dataType: "json",
          },
        },
        schema: {
          data: "items",
          total: (result: any) => result.items.length || 0,
        },
        pageSize: 50,
      }),
      selectable: true,
      pageable: {
        pageSizes: true,
      },
    };

  });
