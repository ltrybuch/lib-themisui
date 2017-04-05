import * as angular from "angular";
import CitiesFixture from "../../tests/fixtures/cities.fixture";

angular.module("thAutocompleteDemo")
  .controller("thAutocompleteDemoCtrl4", function(DataSource) {
    this.defaultModel = null;
    this.multiModel = null;
    this.comboModel = null;

    this.cityOptions = CitiesFixture.getCanadianCities();

    this.options = {
      displayField: "name",
      dataSource: DataSource.createDataSource({
        data: this.cityOptions,
      }),
    };

});
