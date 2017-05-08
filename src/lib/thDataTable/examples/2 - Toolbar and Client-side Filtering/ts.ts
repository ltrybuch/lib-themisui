import * as angular from "angular";
import DataSource from "../../../services/data-source.service";
import FilterSetFactory from "../../../thFilter/filters/filterSet.service";
import { FilterComponentOptions } from "../../../thFilter/thFilter.interface";
import { DataTableUserOptions } from "../../data-table.interfaces";
import { staticColumns, fakeDataObj as expectedDataObj } from "../../tests/fixtures/tabledata";
import { staticFilters, customFilterTypes } from "./filterTypes";

angular.module("thDataTableDemo")
  .controller("thDataTableDemoCtrl2", function(DataSource: DataSource, FilterSet: typeof FilterSetFactory) {
    this.counter = 0;
    this.selectedUIDs = [];

    this.showMessage = function() {
      this.counter++;
      this.message = `showMessage() => ${this.counter}`;
    };

    const dataSource = DataSource.createDataSource({
        data: expectedDataObj.items,
        pageSize: 50,
      });

    const filterSet = new FilterSet({
      onFilterChange: () => {
        dataSource.filter(filterSet.getDataSourceState());
      },
      onInitialized: () => {
        dataSource.filter(filterSet.getDataSourceState());
      },
    });

    const initialFilterState = {
      Birthday: {
        value: "2017-01-01T00:00:00-08:00",
        operator: "<",
      },
      Salary: {
        value: 80000,
        operator: ">",
      },
    };

    this.filterOptions = {
      filterSet,
      staticFilters,
      customFilterTypes,
      initialState: initialFilterState,
    } as FilterComponentOptions;

    this.dataTableOptions = {
      columns: staticColumns,
      dataSource,
      pageable: true,
      selectable: true,
      resizable: true,
      onSelectionChange: selectedUIDs => {
        this.selectedUIDs = selectedUIDs;
      },
    } as DataTableUserOptions;
  });
