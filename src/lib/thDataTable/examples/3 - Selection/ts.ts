import * as angular from "angular";
import { staticColumns, fakeDataObj as expectedDataObj } from "../../tests/fixtures/tabledata";

angular.module("thDataTableDemo")
  .controller("thDataTableDemoCtrl3", function(DataSource) {

    this.selectedIDs = [];

    this.options = {
      columns: staticColumns,
      dataSource: DataSource.createDataSource({
        data: expectedDataObj.items,
        pageSize: 50,
      }),
      pageable: {
        pageSizes: true,
      },
      selectable: true,
      onSelectionChange: (selectedIDs: number[]) => {
        this.selectedIDs = selectedIDs;
      },
    };

  });
