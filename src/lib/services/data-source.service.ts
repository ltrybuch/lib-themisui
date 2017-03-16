import "@progress/kendo-ui/js/kendo.data.js";

export default class DataSource {
  /* tslint:disable:max-line-length */
  /*
   * Local Data Source
   * @see {@link http://docs.telerik.com/kendo-ui/framework/datasource/overview#to-local-data|To Local Data}
   * @see {@link http://docs.telerik.com/kendo-ui/framework/datasource/overview#to-remote-service|To Remote Service}
   */
  /* tslint:enable:max-line-length */
  public createDataSource(options: kendo.data.DataSourceOptions) {
    return new kendo.data.DataSource(options);
  }
}
