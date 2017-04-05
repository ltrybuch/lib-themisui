import * as angular from "angular";
import { alignmentOptions } from "./thGrid.interfaces";
import GridFrameworkService from "./thGridFramework.service";

class Row {
  private hideGutters: boolean;
  private align: alignmentOptions;
  private thGridFramework = new GridFrameworkService();

  /* @ngInject */
  constructor(private $element: JQuery) {}

  $postLink() {
    const cssClasses = this.thGridFramework.getRowClasses({
      hideGutters: this.hideGutters,
      align: this.align,
    });

    this.$element.removeClass();
    this.$element[0].classList.add(...cssClasses.rowClasses);
    this.$element.wrap(`<span class="th-row">`);
  }
}

const RowComponent: angular.IComponentOptions = {
  bindings: {
    hideGutters: "<",
    align: "@",
  },
  controller: Row,
};

export default RowComponent;
