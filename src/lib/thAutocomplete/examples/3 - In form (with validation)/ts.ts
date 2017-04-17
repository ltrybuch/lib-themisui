import * as angular from "angular";

angular.module("thAutocompleteDemo")
  .controller("thAutocompleteDemoCtrl3", function(DataSource) {
    this.required = true;

    this.toggleRequired = function() {
      this.required = !this.required;
    };

    this.reset = function() {
      this.repo = this.response = null;
      this.form.$setPristine();
      this.form.$setUntouched();
    };

    this.submit = function() {
      return this.response = this.form.$valid ? {
        $valid: this.form.$valid,
      } : {
        $error: {
          repo: this.form.repo.$error,
          github1: this.form.github1.$error,
          github2: this.form.github2.$error,
        },
      };
    };

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
    };

    this.multipleOptions = {
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

    this.comboOptions = {
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
