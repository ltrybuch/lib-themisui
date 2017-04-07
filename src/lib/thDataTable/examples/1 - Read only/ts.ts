import * as angular from "angular";
import { staticColumns, fakeDataObj as expectedDataObj } from "../../tests/fixtures/tabledata";

angular.module("thDataTableDemo")
  .controller("thDataTableDemoCtrl1", function(DataSource) {

    this.options = {
      columns: staticColumns,
      dataSource: DataSource.createDataSource({
        data: expectedDataObj.items,
        pageSize: 50,
      }),
      pageable: {
        pageSizes: true,
      },
    };
  });
