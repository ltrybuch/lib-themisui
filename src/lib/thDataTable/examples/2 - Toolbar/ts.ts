import * as angular from "angular";
import { staticColumns, fakeDataObj as expectedDataObj } from "../../tests/fixtures/tabledata";

angular.module("thDataTableDemo")
  .controller("thDataTableDemoCtrl2", function(DataSource) {

    this.counter = 0;
    this.selectedUIDs = [];

    this.showMessage = function() {
      this.counter++;
      this.message = `showMessage() => ${this.counter}`;
    };

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
      onSelectionChange: (selectedUIDs: string[]) => {
        this.selectedUIDs = selectedUIDs;
      },
    };

  });
