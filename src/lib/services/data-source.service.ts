import angular = require("angular");
import "@progress/kendo-ui/js/kendo.data.js";

class DataSource {
  /*
   * Local Data Source
   * options ref: http://docs.telerik.com/kendo-ui/framework/datasource/overview#to-local-data
   * options ref: http://docs.telerik.com/kendo-ui/framework/datasource/overview#to-remote-service
   */
  public createDataSource(options: any) {
    return new kendo.data.DataSource(options);
  }
}

angular.module("ThemisComponents").service("DataSource", DataSource);
