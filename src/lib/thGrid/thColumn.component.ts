import * as angular from "angular";
import GridFrameworkService from "./thGridFramework.service";

class Column {
  private thRow: any;
  private columns: string;
  private columnsLg: string;
  private columnsSm: string;
  private columnsXs: string;
  private hideLg: boolean;
  private hideMd: boolean;
  private hideSm: boolean;
  private hideXs: boolean;
  private thGridFramework = new GridFrameworkService();

  /* @ngInject */
  constructor(private $element: JQuery) {}

  $onInit() {
    if (typeof this.thRow === "undefined") {
      // Should we also do a check for the direct parent here?
      // Having .frow in the ancester tree isn't enough.
      throw new Error("A thColumn component must have a thGrid component as its parent");
    }
  }

  $postLink() {
    const cssClasses = this.thGridFramework.getColumnClasses({
      columns: this.columns,
      columnsLg: this.columnsLg,
      columnsSm: this.columnsSm,
      columnsXs: this.columnsXs,
      hideLg: this.hideLg,
      hideMd: this.hideMd,
      hideSm: this.hideSm,
      hideXs: this.hideXs,
    });

    this.$element.removeClass();
    this.$element[0].classList.add(...cssClasses.columnClasses);
  }
}

const ColumnComponent: angular.IComponentOptions = {
  bindings: {
    columns: "@",
    columnsLg: "@",
    columnsSm: "@",
    columnsXs: "@",
    hideLg: "<",
    hideMd: "<",
    hideSm: "<",
    hideXs: "<",
  },
  controller: Column,
  require: {
    thRow: "^^",
  },
};
export default ColumnComponent;
