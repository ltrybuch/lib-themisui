import * as angular from "angular";
import { staticColumns, staticData } from "../../fixtures/tabledata";

angular.module("thDataTableDemo")
  .controller("thDataTableDemoCtrl1", function(DataSource) {

    this.options = {
      columns: staticColumns,
      dataSource: DataSource.createDataSource({
        data: staticData,
        pageSize: 5,
      }),
      pageable: {
        pageSizes: true,
      },
    };
  });
