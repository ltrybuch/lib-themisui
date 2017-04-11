const SpecHelpers: any = require("spec_helpers");
import * as expectedCalendars from "./fixtures/calendars";
import * as angular from "angular";
import "angular-mocks";
import CalendarDataSource from "../calendars/calendar-data-source.service";
import { CalendarsController } from "../calendars/calendars.component";
import { fakeResponse } from "../../services/http-mocking.service";

describe("ThemisComponents: Component", () => {

  fakeResponse(/(calendars)/, expectedCalendars.apiNestedItems);
  fakeResponse(/calendars\/1/, expectedCalendars.apiNestedFirstItem, "POST");
  fakeResponse(/calendars\/2/, expectedCalendars.apiNestedSecondItem, "POST");
  const calendarDataSource = new CalendarDataSource({
    transport: {
      read: {
        url: "calendars",
        dataType: "json",
      },
      update: {
        type: "post",
        dataType: "json",
        url: "calendars",
      },
    },
    schema: {
      data: "data",
      model: {
        id: "id",
        fields: {
          id: { type: "number" },
          visible: { type: "boolean" },
          color: { type: "string" },
        },
      },
    },
    // "autoSync": true makes the request as expected, but doesn't seem to update the entries in the UI
    autoSync: false,
  });

  let scope = {};

  beforeEach(angular.mock.module("ThemisComponents"));

  beforeEach(() => {
    scope = {
      options: {
        dataSource: calendarDataSource,
      },
    };
  });

  describe("CalendarsComponent", () => {
    it("creates a calendars widget", () => {
      let {element} = SpecHelpers.compileDirective(
        `<th-calendars options="options"></th-calendars>`,
        scope,
      );
      expect(element.find("ul").length).toEqual(1);
    });
  });

  describe("CalendarsController", () => {
    let $componentController: ng.IComponentControllerService;

    beforeEach(inject((_$componentController_: ng.IComponentControllerService) => {
      $componentController = _$componentController_;
    }));

    describe("#onInit", () => {
      it("calls #validateArgs()", function(done) {
        const $ctrl = $componentController("thCalendars", {}, scope) as CalendarsController;
        spyOn($ctrl, "validateArgs");
        $ctrl.$onInit().then(() => {
          expect($ctrl.validateArgs).toHaveBeenCalledTimes(1);
          done();
        });
      });

      it("calls #setCalendars()", function(done) {
        const $ctrl = $componentController("thCalendars", {}, scope) as CalendarsController;
        spyOn($ctrl, "setCalendars");
        $ctrl.$onInit().then(() => {
          expect($ctrl.setCalendars).toHaveBeenCalledTimes(1);
          done();
        });
      });
    });

    describe("#setCalendars()", () => {
      it("retrieves and sets calendars as instance property", function(done) {
        const $ctrl = $componentController("thCalendars", {}, scope) as CalendarsController;
        $ctrl.setCalendars().then(() => {
          expect($ctrl.calendars).toEqual(expectedCalendars.items);
          done();
        });
      });
    });

    describe("#setCalendarBeingEdited()", () => {
      it("sets current active calendar on an instance property", () => {
        const $ctrl = $componentController("thCalendars", {}, scope) as CalendarsController;
        expect($ctrl.calendarBeingEdited).toEqual(undefined);
        $ctrl.setCalendarBeingEdited(expectedCalendars.items[0]);
        expect($ctrl.calendarBeingEdited).toEqual(expectedCalendars.items[0]);
      });
    });

    describe("#setColorForCalendarBeingEdited()", () => {
      it("sets color for currently active calendar", () => {
        const $ctrl = $componentController("thCalendars", {}, scope) as CalendarsController;
        $ctrl.setCalendarBeingEdited(expectedCalendars.items[0]);
        expect($ctrl.calendarBeingEdited.color).toEqual("#CCCCCC");
        $ctrl.setColorForCalendarBeingEdited("#FFFFFF");
        expect($ctrl.calendarBeingEdited.color).toEqual("#FFFFFF");
      });
    });

  });

});
