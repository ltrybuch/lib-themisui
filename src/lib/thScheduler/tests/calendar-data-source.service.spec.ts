import * as expectedCalendars from "./fixtures/calendars";
import CalendarDataSource from "../calendars/calendar-data-source.service";
import { fakeResponse } from "../../services/http-mocking.service";
import CalendarInterface from "../calendars/calendar.interface";

describe("ThemisComponents : thScheduler : CalendarDataSource", function() {
  let calendarDataSource: CalendarDataSource;

  beforeEach(function() {
    fakeResponse(/calendars/, expectedCalendars.apiNestedItems);
    // #for-discussion Should the service return an instance ready-made?
    calendarDataSource = new CalendarDataSource({
      transport: {
        read: {
          url: "calendars",
          dataType: "json"
        }
      },
      schema: {
        data: "data",
        model: {
          id: "id",
          fields: {
            id: { from: "id", type: "number" },
            visible: { from: "visible", type: "boolean" }
          }
        }
      }
    });
  });

  describe("#getIds", function() {
    it("returns calendar ids", function(done) {
      calendarDataSource.getIds()
        .then(function(data) {
          expect(data).toEqual(expectedCalendars.ids);
          done();
        });
    });

  });

  describe("getters/setters", function() {

    beforeEach(function(done) {
      calendarDataSource.fetch().then(done);
    });

    describe("#isVisible", function() {
      it("returns true if calendar is visible", function() {
        expect(calendarDataSource.isVisible(2)).toEqual(true);
      });

      it("returns false if calendar is not visible", function() {
        expect(calendarDataSource.isVisible(1)).toEqual(false);
      });
    });

    describe("#setVisible", function() {
      it("sets 'visible' to true if calendar is visible", function() {
        let calendar = {id: 1, visible: true} as CalendarInterface;
        expect(calendarDataSource.isVisible(1)).toEqual(false);
        calendarDataSource.setVisible(calendar);
        expect(calendarDataSource.isVisible(1)).toEqual(true);
      });

      it("sets 'visible' to false if calendar is not visible", function() {
        let calendar = {id: 2, visible: false} as CalendarInterface;
        expect(calendarDataSource.isVisible(2)).toEqual(true);
        calendarDataSource.setVisible(calendar);
        expect(calendarDataSource.isVisible(2)).toEqual(false);
      });
    });
  });

});
