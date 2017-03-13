import * as expectedCalendars from "./tests/fixtures/calendars";
import CalendarDataSource from "./calendar-data-source.service";
import { fakeResponse } from "../services/http-mocking.service";

describe("ThemisComponents : thScheduler : CalendarDataSource", function() {
  // #for-discussion Should the service return an instance ready-made?
  const calendarDataSource = new CalendarDataSource();

  describe("#getIds", function() {

    it("returns calendar ids", function(done) {
      fakeResponse(/calendars/, expectedCalendars.apiNestedItems);

      calendarDataSource.getIds()
        .then(function(data) {
          expect(data).toEqual(expectedCalendars.ids);
          done();
        });
    });

  });

});
