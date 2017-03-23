import * as angular from "angular";
import { staticColumns, staticData } from "../../fixtures/tabledata";

angular.module("thDataGridDemo")
  .controller("thDataGridDemoCtrl3", function(DataSource) {

    this.selectedIDs = [];

    this.options = {
      columns: staticColumns,
      dataSource: DataSource.createDataSource({
        data: staticData,
        pageSize: 5,
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
