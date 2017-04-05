import * as angular from "angular";
import CitiesFixture from "../../tests/fixtures/cities.fixture";

angular.module("thAutocompleteDemo")
  .controller("thAutocompleteDemoCtrl6", function(DataSource) {
    this.defaultModel = null;
    this.multiModel = null;
    this.comboModel = null;

    this.cityOptions = CitiesFixture.getCanadianCities();

    const rowTemplate = `
      <strong>#: data.name #</strong>, #: data.province #
    `;

    this.defaultOptions = {
      rowTemplate,
      displayField: "name",
      dataSource: DataSource.createDataSource({
        data: this.cityOptions,
      }),
    };

    this.multiOptions = {
      rowTemplate,
      displayField: "name",
      dataSource: DataSource.createDataSource({
        data: this.cityOptions,
      }),
    };

    this.comboOptions = {
      rowTemplate,
      displayField: "name",
      dataSource: DataSource.createDataSource({
        data: this.cityOptions,
      }),
    };
});
