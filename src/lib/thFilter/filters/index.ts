import * as angular from "angular";

import "./autocomplete/";
import "./date/";
import "./input/";
import "./number/";
import "./select/";
import "./time/";
import "./filterBase.service";
import FilterSet from "./filterSet.service";

angular.module("ThemisComponents")
  .factory("FilterSet", () => FilterSet);
