import * as angular from "angular";
import DataSource from "../../../services/data-source.service";
import FilterSetFactory from "../../../thFilter/filters/filterSet.service";
import { FilterComponentOptions, FilterSetState } from "../../../thFilter/thFilter.interface";
import { DataTableUserOptions } from "../../data-table.interfaces";
import { staticColumns } from "../../tests/fixtures/tabledata";
import { staticFilters, customFilterTypes } from "./filterTypes";
import generateFakeResponseWithPageSize from "./fakeResponse";

const url = "/tabledata";

angular.module("thDataTableDemo")
  .controller("thDataTableDemoCtrl5", function(DataSource: DataSource, FilterSet: typeof FilterSetFactory) {

    const dataSource = DataSource.createDataSource({
      transport: {
        read: {
          url,
          dataType: "json",
        },
        parameterMap: function(data) {
          const filterState = (data.filter && data.filter.filters[0] as FilterSetState) || {};
          const filterData = Object.keys(filterState)
            .reduce((collector, key) => {
              return {
                ...collector,
                [key]: (filterState[key].operator || "") + filterState[key].value,
              };
            }, {});

          const pageData = {
            page: data.page,
            limit: data.pageSize,
          };
          return { ...pageData, ...filterData };
        },
      },
      schema: {
        data: "items",
        total: "total",
      },
      pageSize: 50,
      serverPaging: true,
      serverFiltering: true,
    });

    const filterSet = new FilterSet({
      onFilterChange: () => {
        dataSource.filter(filterSet.getState());
      },
    });

    this.filterOptions = {
      filterSet,
      staticFilters,
      customFilterTypes,
    } as FilterComponentOptions;

    this.dataTableOptions = {
      columns: staticColumns,
      dataSource,
      resizable: true,
      selectable: true,
      pageable: true,
    } as DataTableUserOptions;

  });

[50, 100, 150, 200].forEach((pageSize) => {
  generateFakeResponseWithPageSize(url, pageSize);
});
