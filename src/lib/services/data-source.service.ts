import "@progress/kendo-ui/js/kendo.data.js";
/**
 * FIXME: Rename to DataSourceFactory and return a type of "DataSource"
 * that exposes the fetch method and anything else required from kendo.data.DataSource
 */
export default class DataSource {
  /* tslint:disable:max-line-length */
  /**
   * Local Data Source
   * @see {@link http://docs.telerik.com/kendo-ui/framework/datasource/overview#to-local-data|To Local Data}
   * @see {@link http://docs.telerik.com/kendo-ui/framework/datasource/overview#to-remote-service|To Remote Service}
   */
  // FIXME: This should be changed to a "static" method, as other DataSources now do
  /* tslint:enable:max-line-length */
  public createDataSource(options: kendo.data.DataSourceOptions) {
    return new kendo.data.DataSource(options);
  }
}
