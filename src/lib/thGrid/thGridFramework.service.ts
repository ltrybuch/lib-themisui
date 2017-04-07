import * as grid from "./thGrid.interfaces";
import { bootstrapCssClasses } from "./thGrid.cssClasses";

export default class GridFrameworkService {
  private cssClasses: grid.CssFrameworkClasses = bootstrapCssClasses;

  getRowClasses(config: grid.RowConfig = {}) {
    return {
      rowClasses: [
        this.cssClasses.row.row,
        config.hideGutters ?
          this.cssClasses.row.noGutters || null :
          this.cssClasses.row.gutters || null,
        this.cssClasses.row.alignment[config.align || "centre"] || null,
      ].filter(cssClass => cssClass !== null),
    };
  }

  getColumnClasses(config: grid.ColumnConfig) {
    return {
      columnClasses: [
        this.cssClasses.column.column,
        config.columns ? this.cssClasses.column.columnsMd.replace("xx", config.columns) : null,
        config.columnsLg ? this.cssClasses.column.columnsLg.replace("xx", config.columnsLg) : null,
        config.columnsSm ? this.cssClasses.column.columnsSm.replace("xx", config.columnsSm) : null,
        config.columnsXs ? this.cssClasses.column.columnsXs.replace("xx", config.columnsXs) : null,
        config.hideLg ? this.cssClasses.column.hideLg : null,
        config.hideMd ? this.cssClasses.column.hideMd : null,
        config.hideSm ? this.cssClasses.column.hideSm : null,
        config.hideXs ? this.cssClasses.column.hideXs : null,
      ].filter(cssClass => cssClass !== null),
    };
  }
}
