angular.module("thAutocompleteDemo")
  .controller("thAutocompleteDemoCtrl5", function(DataSource) {

    this.defaultDelegate = {
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

    this.cityOptions = [
      {id: 0, name: "Toronto", province: "Ontario"},
      {id: 1, name: "Montreal", province: "Quebec"},
      {id: 2, name: "Calgary", province: "Alberta"},
      {id: 3, name: "Ottawa", province: "Ontario"},
      {id: 4, name: "Edmonton", province: "Alberta"},
      {id: 5, name: "Mississauga", province: "Ontario"},
      {id: 6, name: "Winnipeg", province: "Manitoba"},
      {id: 7, name: "Vancouver", province: "British Columbia"},
      {id: 8, name: "Brampton", province: "Ontario"},
      {id: 9, name: "Hamilton", province: "Ontario"},
      {id: 10, name: "Quebec City", province: "Quebec"},
      {id: 11, name: "Surrey", province: "British Columbia"},
      {id: 12, name: "Laval", province: "Quebec"},
      {id: 13, name: "Halifax", province: "Nova Scotia"},
      {id: 14, name: "London", province: "Ontario"},
      {id: 15, name: "Markham", province: "Ontario"},
      {id: 16, name: "Vaughan", province: "Ontario"},
      {id: 17, name: "Gatineau", province: "Quebec"},
      {id: 18, name: "Longueuil", province: "Quebec"},
      {id: 19, name: "Burnaby", province: "British Columbia"},
    ];

    this.delegate = {
      displayField: "name",
      dataSource: DataSource.createDataSource({
        data: this.cityOptions,
      }),
    };

});
