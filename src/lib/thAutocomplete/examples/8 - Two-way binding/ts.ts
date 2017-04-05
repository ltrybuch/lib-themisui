import * as angular from "angular";

import CitiesFixture from "../../tests/fixtures/cities.fixture";

angular.module("thAutocompleteDemo")
  .controller("thAutocompleteDemoCtrl8", function(DataSource) {
    this.defaultModel = {id: 6, name: "Winnipeg", province: "Manitoba"};

    this.multiModel = [2, 19];

    this.comboModel = {id: 12, name: "Laval", province: "Quebec"};

    this.cityOptions = CitiesFixture.getCanadianCities();

    this.clearDefaultModel = () => {
      this.defaultModel = null;
    };

    this.clearMultiModel = () => {
      this.multiModel = null;
    };

    this.clearComboModel = () => {
      this.comboModel = null;
    };

    this.onChange = () => {
      console.log("Changed!");
    };

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
