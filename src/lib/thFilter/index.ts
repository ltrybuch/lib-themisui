import * as angular from "angular";

import "./filters/";
import "./thCustomFilterRow.directive";
import "./thCustomFilters.component";
import "./thSearchRow.directive";
import "./thStaticFilters.directive";
import "./thCustomFilterConverter.service";
import FilterComponent from "./thFilter.component";

angular.module("ThemisComponents")
  .component("thFilter", FilterComponent);
