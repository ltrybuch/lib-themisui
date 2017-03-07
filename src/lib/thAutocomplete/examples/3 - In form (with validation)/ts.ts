angular.module("thAutocompleteDemo")
  .controller("thAutocompleteDemoCtrl3", function(DataSource, ValidatorService) {
    this.required = true;

    this.toggleRequired = function() {
      this.required = !this.required;
    };

    this.reset = function() {
      this.repo = this.response = null;
      this.form.$setPristine();
      return this.form.$setUntouched();
    };

    this.submit = function() {
      return this.response = this.form.$valid ? {
        $valid: this.form.$valid
      } : {
        $error: this.form.repo.$error
      };
    };

    this.validate = function(event: any) {
      event.preventDefault();
      this.validator = ValidatorService.create({
        element: jQuery("form")[0],
      });

      this.validator.validate();

      this.submit();
    };

    this.defaultDelegate = {
      displayField: "full_name",
      dataSource: DataSource.createDataSource({
        serverFiltering: true,
        transport: {
          read: {
            url: "//api.github.com/search/repositories",
            type: "get",
            dataType: "json"
          },
          parameterMap: (data: any, action: String) => {
            if (action === "read" && data.filter) {
              return {
                q: data.filter.filters[0] ? data.filter.filters[0].value : ""
              };
            } else {
              return data;
            }
          }
        },
        schema: {
          data: "items"
        }
      })
    };

    this.multipleDelegate = {
      displayField: "full_name",
      dataSource: DataSource.createDataSource({
        serverFiltering: true,
        transport: {
          read: {
            url: "//api.github.com/search/repositories",
            type: "get",
            dataType: "json"
          },
          parameterMap: (data: any, action: String) => {
            if (action === "read" && data.filter) {
              return {
                q: data.filter.filters[0] ? data.filter.filters[0].value : ""
              };
            } else {
              return data;
            }
          }
        },
        schema: {
          data: "items"
        }
      })
    };

    this.comboDelegate = {
      displayField: "full_name",
      dataSource: DataSource.createDataSource({
        serverFiltering: true,
        transport: {
          read: {
            url: "//api.github.com/search/repositories",
            type: "get",
            dataType: "json"
          },
          parameterMap: (data: any, action: String) => {
            if (action === "read" && data.filter) {
              return {
                q: data.filter.filters[0] ? data.filter.filters[0].value : ""
              };
            } else {
              return data;
            }
          }
        },
        schema: {
          data: "items"
        }
      })
    };
});
