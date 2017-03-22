import * as angular from "angular";
import { staticColumns, staticData } from "../../fixtures/tabledata";

angular.module("thDataGridDemo")
  .controller("thDataGridDemoCtrl2", function(DataSource) {

    this.counter = 0;

    this.showMessage = function() {
      this.counter++;
      this.message = `showMessage() => ${this.counter}`;
    };

    this.options = {
      columns: staticColumns,
      dataSource: DataSource.createDataSource({
        data: staticData
      })
    };

  });

