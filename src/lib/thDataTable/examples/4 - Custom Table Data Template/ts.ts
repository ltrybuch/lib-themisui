import * as angular from "angular";
import { staticColumns, fakeDataObj as expectedDataObj } from "../../tests/fixtures/tabledata";
const rowActionsTemplate = require("./row-actions.template.html") as string;

angular.module("thDataTableDemo")
  .controller("thDataTableDemoCtrl4", function(DataSource) {
    const actionsColumn = {
      // See here for all possible configurations for column (e.g. width):
      // http://docs.telerik.com/kendo-ui/api/javascript/ui/grid#configuration-columns
      command: {
        template: rowActionsTemplate,
      },
    };

    this.onEditHandler = (rowData: any) => {
      this.rowEdited = rowData;
    };

    this.options = {
      columns: [
        ...staticColumns,
        actionsColumn,
      ],
      dataSource: DataSource.createDataSource({
        data: expectedDataObj.items,
        pageSize: 50,
      }),
      pageable: {
        pageSizes: true,
      },
      onSelectionChange: (selectedUIDs: string[]) => {
        this.selectedUIDs = selectedUIDs;
      },
    };

  });
