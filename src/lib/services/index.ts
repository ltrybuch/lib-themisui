import * as angular from "angular";

import Utilities from "./utilities.service";
import DataSource from "./data-source.service";
import SchedulerDataSource from "./scheduler-data-source.service";

angular.module("ThemisComponents")
  .service("DataSource", DataSource)
  .service("SchedulerDataSource", SchedulerDataSource)
  .service("Utilities", Utilities);
