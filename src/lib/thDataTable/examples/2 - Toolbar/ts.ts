import * as angular from "angular";
import { staticColumns, staticData } from "../../fixtures/tabledata";

angular.module("thDataTableDemo")
  .controller("thDataTableDemoCtrl2", function(DataSource) {

    this.counter = 0;
    this.selectedIDs = [];

    this.showMessage = function() {
      this.counter++;
      this.message = `showMessage() => ${this.counter}`;
    };

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
      actionList: [
        {name: "Show Message", ngClick: this.showMessage},
        {name: "Update", href: "#"},
        {name: "Delete", href: "#"},
      ],
    };

  });

