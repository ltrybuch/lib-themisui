import * as angular from "angular";

import CitiesFixture from "../../tests/fixtures/cities.fixture";

angular.module("thAutocompleteDemo")
  .controller("thAutocompleteDemoCtrl7", function(DataSource) {
    this.defaultModel = null;
    this.multiModel = null;
    this.comboModel = null;

    this.cityOptions = CitiesFixture.getCitiesWithLongNames();

    this.defaultOptions = {
      displayField: "name",
      dataSource: DataSource.createDataSource({
        data: this.cityOptions,
      }),
    };

    this.multiOptions = {
      displayField: "name",
      dataSource: DataSource.createDataSource({
        data: this.cityOptions,
      }),
    };

    this.comboOptions = {
      displayField: "name",
      dataSource: DataSource.createDataSource({
        data: this.cityOptions,
      }),
    };
});
