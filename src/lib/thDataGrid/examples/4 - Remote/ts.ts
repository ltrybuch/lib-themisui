import * as angular from "angular";
import { remoteColumns } from "../../fixtures/tabledata";

angular.module("thDataGridDemo")
  .controller("thDataGridDemoCtrl4", function(DataSource) {

    this.options = {
      columns: remoteColumns,
      dataSource: DataSource.createDataSource({
        transport: {
          read: {
            url: "https://api.github.com/search/repositories?q=vancouver&limit=20",
            dataType: "json",
          },
        },
        schema: {
          data: "items",
          total: (result: any) => result.items.length || 0,
        },
        pageSize: 5,
      }),
      selectable: true,
      pageable: {
        pageSizes: true,
      },
    };

  });
