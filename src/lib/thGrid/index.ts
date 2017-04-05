import * as angular from "angular";

import RowComponent from "./thRow.component";
import ColumnComponent from "./thColumn.component";

angular.module("ThemisComponents")
  .component("thRow", RowComponent)
  .component("thColumn", ColumnComponent);
