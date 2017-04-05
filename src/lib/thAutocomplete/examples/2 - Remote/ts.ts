import * as angular from "angular";

angular.module("thAutocompleteDemo")
  .controller("thAutocompleteDemoCtrl2", function(DataSource) {

    this.options = {
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
    };

});
