import * as angular from "angular";
import DataSource from "../../../services/data-source.service";
import { DataTableUserOptions } from "../../data-table.interfaces";
import { staticColumns, fakeDataObj as expectedDataObj } from "../../tests/fixtures/tabledata";

angular.module("thDataTableDemo")
  .controller("thDataTableDemoCtrl1", function(DataSource: DataSource) {

    this.dataTableOptions = {
      columns: staticColumns,
      dataSource: DataSource.createDataSource({
        data: expectedDataObj.items,
        pageSize: 50,
      }),
      pageable: true,
    } as DataTableUserOptions;
  });
