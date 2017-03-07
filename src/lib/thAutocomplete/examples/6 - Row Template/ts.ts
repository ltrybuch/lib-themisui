angular.module("thAutocompleteDemo")
  .controller("thAutocompleteDemoCtrl6", function(DataSource) {
    this.defaultModel = null;
    this.multipleModel = null;
    this.comboModel = null;

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
      {id: 19, name: "Burnaby", province: "British Columbia"}
    ];

    this.rowTitleTemplate = "Name: #: data.name # :: Province: #: data.province #";

    this.rowTemplate = `
      <span class="k-state-default"><strong>#: data.name #</strong>, #: data.province #</span>
    `;

    this.defaultDelegate = {
      displayField: "name",
      dataSource: DataSource.createDataSource({
        data: this.cityOptions
      })
    };

    this.multiDelegate = {
      displayField: "name",
      dataSource: DataSource.createDataSource({
        data: this.cityOptions
      })
    };

    this.comboDelegate = {
      displayField: "name",
      dataSource: DataSource.createDataSource({
        data: this.cityOptions
      })
    };
});
