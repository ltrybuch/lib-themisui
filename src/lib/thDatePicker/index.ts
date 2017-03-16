import * as angular from "angular";
import { DatepickerService } from "./thDatePicker.service";
import "../services/validator.service";
import "./thDatePicker.component";

angular.module("ThemisComponents")
  .service("DatepickerService", DatepickerService);
