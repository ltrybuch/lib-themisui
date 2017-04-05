import * as angular from "angular";
import CitiesFixture from "../../tests/fixtures/cities.fixture";

angular.module("thAutocompleteDemo")
  .controller("thAutocompleteDemoCtrl5", function(DataSource) {

    this.defaultOptions = {
      displayField: "full_name",
      dataSource: DataSource.createDataSource({
        serverFiltering: true,
        transport: {
          read: {
            url: "//api.github.com/search/repositories",
            type: "get",
            dataType: "json",
          },
          parameterMap: (data: any, action: String) => {
            if (action === "read" && data.filter) {
              return {
                q: data.filter.filters[0] ? data.filter.filters[0].value : "",
              };
            } else {
              return data;
            }
          },
        },
        schema: {
          data: "items",
        },
      }),
      groupBy: "language",
    };

    this.cityOptions = CitiesFixture.getCanadianCities();

    this.options = {
      displayField: "name",
      dataSource: DataSource.createDataSource({
        data: this.cityOptions,
      }),
      groupBy: "province",
    };

});
