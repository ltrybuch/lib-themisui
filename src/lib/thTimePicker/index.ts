import * as angular from "angular";
import { TimePickerService } from "./thTimePicker.service";
import { TimePickerComponent } from "./thTimePicker.component";
import "./thTimePicker.component";

angular.module("ThemisComponents")
  .component("thTimePicker", TimePickerComponent)
  .service("TimePickerService", TimePickerService);
