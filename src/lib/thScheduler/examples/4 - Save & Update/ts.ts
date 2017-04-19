import * as angular from "angular";
import { fakeResponse } from "../../../services/http-mocking.service";
import * as expectedEntries from "../../tests/fixtures/entries";
import * as expectedCalendars from "../../tests/fixtures/calendars";
import SchedulerController from "./demoScheduler.controller";
import EditModalController from "./editModal.controller";

fakeResponse(/calendars/, expectedCalendars.apiNestedItems);
fakeResponse(/calendar_id=1/, expectedEntries.apiNestedOneCalendarEntriesItems);
fakeResponse(/calendar_id=2/, expectedEntries.apiNestedSecondCalendarEntriesItems);
fakeResponse(/calendar_entries\/[0-9]+/, { data: {} }, "PATCH");
fakeResponse(/calendar_entries/, { data: {} }, "POST");

angular.module("thSchedulerDemo")
  .controller("thSchedulerDemoCtrl4", SchedulerController)
  .controller("editModalController", ($scope) => new EditModalController($scope.modal));
