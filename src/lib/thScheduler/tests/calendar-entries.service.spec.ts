import * as expectedEntries from "./fixtures/entries";
import * as expectedCalendars from "./fixtures/calendars";
import CalendarEntriesService from "../calendar-entries.service";
import CalendarDataSourceMock from "./calendar-data-source.service.mock";
import {fakeResponse} from "../../services/http-mocking.service";

describe("ThemisComponents: thScheduler : CalendarEntriesService", function() {
  let calendarEntryService: CalendarEntriesService;
  let calendarDataSourceMock: CalendarDataSourceMock;

  beforeEach(function() {
    calendarDataSourceMock = new CalendarDataSourceMock();
    calendarEntryService = new CalendarEntriesService({
      schema: {
        data: "data",
        model: {
          fields: {
            end: { from: "end", type: "date" },
            id: { from: "id", type: "number" },
            start: { from: "start", type: "date" },
            title: { from: "title" },
            calendar_id: { from: "calendar_id" },
          },
          id: "id",
        },
      },
    }, calendarDataSourceMock);
  });

  describe("#getEntriesForCalendar", function() {

    it("returns the entries for one calendar", function(done) {
      fakeResponse(/calendar_id=1/, expectedEntries.apiNestedOneCalendarEntriesItems);

      calendarEntryService.getEntriesForCalendar(expectedEntries.oneCalendarEntriesId)
        .then(function(data) {
          expect(data).toEqual(expectedEntries.oneCalendarEntriesItems);
          done();
        });
    });
  });

  describe("#getEntriesForCalendars", function() {

    it("returns entries for visible calendars", function(done) {
      fakeResponse(/calendar_id=2/, expectedEntries.apiNestedSecondCalendarEntriesItems);

      calendarEntryService.getEntriesForCalendars()
        .then(function(data) {
          expect(data).toEqual(expectedEntries.secondCalendarEntriesItems);
          done();
        });
    });

  });

  describe("#addEntriesForCalendars", function() {

    it("appends newly retrieved entries to instance entries data source", function(done) {
      fakeResponse(/calendar_id=1/, expectedEntries.oneCalendarEntriesItems);

      const entriesDataSource = calendarEntryService.getEntriesDataSource();
      expect(entriesDataSource.data().length).toEqual(0);
      calendarEntryService.addEntriesForCalendar(expectedCalendars.ids[0])
        .then(function() {
          const firstEntryRaw = expectedEntries.firstCalendarEntriesItems[0];
          /**
           * #kendo-coupling
           * We're using kendo model objects directly here, should consider adding accessors.
           */
          const {id, calendar_id, title} = <any>entriesDataSource.get(firstEntryRaw.id).toJSON();
          expect(entriesDataSource.data().length).toBe(2);
          expect(id).toEqual(firstEntryRaw.id);
          expect(calendar_id).toEqual(firstEntryRaw.calendar_id);
          expect(title).toEqual(firstEntryRaw.title);
          done();
        });
    });

  });

  describe("#onVisibilityChanged", function() {

    it("calls addEntriesForCalendar once for each calendar", function(done) {
      fakeResponse(/calendar_id=2/, expectedEntries.secondCalendarEntriesItems);

      spyOn(calendarEntryService, "addEntriesForCalendar");
      calendarDataSourceMock.triggerVisibilityEvent().then(function() {
        expect(calendarEntryService.addEntriesForCalendar).toHaveBeenCalledTimes(1);
        expect(calendarEntryService.addEntriesForCalendar).toHaveBeenCalledWith(2);
        done();
      });
    });

  });

  describe("#removeEntry", function() {
    let entriesDataSource: kendo.data.DataSource;

    beforeEach(function() {
      fakeResponse(/calendar_id=2/, expectedEntries.apiNestedSecondCalendarEntriesItems);
      entriesDataSource = calendarEntryService.getEntriesDataSource();
    });

    it("removes only a single entry", function(done) {
      entriesDataSource.fetch().then(function() {
        const entries = entriesDataSource.data();
        expect(entries.length).toEqual(2);
        calendarEntryService.removeEntry(entries[0]);
        expect(entries.length).toEqual(1);
        done();
      });
    });

    it("removes the correct entry", function(done) {
      entriesDataSource.fetch().then(function() {
        const entries = entriesDataSource.data();
        const firstEntry = entries[0];
        const secondEntry = entries[1];

        calendarEntryService.removeEntry(firstEntry);

        const remainingEntry = entries[0];
        expect(remainingEntry.title).toBe(secondEntry.title);
        done();
      });
    });
  });

});
