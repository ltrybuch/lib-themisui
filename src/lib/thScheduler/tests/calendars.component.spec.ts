const SpecHelpers: any = require("spec_helpers");
import * as expectedCalendars from "./fixtures/calendars";
import * as angular from "angular";
import "angular-mocks";
import CalendarDataSource from "../calendars/calendar-data-source.service";
import { CalendarsController } from "../calendars/calendars.component";

describe("ThemisComponents: Component", () => {

  let scope: {
    options: {
      dataSource: CalendarDataSource,
    },
  };

  beforeEach(angular.mock.module("ThemisComponents"));

  beforeEach(() => {
    scope = {
      options: {
        dataSource: new CalendarDataSource({
          data: expectedCalendars.items,
        }),
      },
    };
  });

  describe("CalendarsComponent", () => {
    it("creates a calendars widget", () => {
      let {element} = SpecHelpers.compileDirective(
        `<th-calendars options="options"></th-calendars>`,
        scope,
      );
      expect(element.find(".calendars-widget").length).toEqual(1);
    });
  });

  describe("CalendarsController", () => {
    let $componentController: ng.IComponentControllerService;

    beforeEach(inject((_$componentController_: ng.IComponentControllerService) => {
      $componentController = _$componentController_;
    }));

    describe("#onInit()", () => {
      it("retrieves and embeds calendars as a public instance member", (done) => {
        const $ctrl = $componentController("thCalendars", {}, scope) as CalendarsController;

        $ctrl.$onInit()
          .then(function() {
            expect($ctrl.calendars).toEqual(expectedCalendars.items);
            done();
          });
        });
    });

  });

});
