angular.module("thAutocompleteDemo")
  .controller("thAutocompleteDemoCtrl7", function(DataSource) {
    this.defaultModel = null;
    this.multipleModel = null;
    this.comboModel = null;

    this.cityOptions = [
      {id: 0, name: "Toronto Toronto Toronto TorontoTorontoTorontoToronto TorontoToronto Toronto"},
      {id: 1, name: "Montreal"},
      {id: 2, name: "Calgary"},
      {id: 3, name: "Ottawa"},
      {id: 4, name: "Edmonton"},
      {id: 5, name: "Mississauga"},
      {id: 6, name: "Winnipeg"},
      {id: 7, name: "Vancouver Vancouver Vancouver Vancouver Vancouver Vancouver Vancouver"},
      {id: 8, name: "Brampton"},
      {id: 9, name: "Hamilton"},
      {id: 10, name: "Quebec City"},
      {id: 11, name: "Surrey"},
      {id: 12, name: "Laval"},
      {id: 13, name: "Halifax"},
      {id: 14, name: "London"},
      {id: 15, name: "Markham"},
      {id: 16, name: "Vaughan"},
      {id: 17, name: "Gatineau"},
      {id: 18, name: "Longueuil"},
      {id: 19, name: "Burnaby"}
    ];

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