import * as expectedEntries from "./fixtures/entries";
import * as expectedCalendars from "./fixtures/calendars";
import { CalendarEntriesService } from "../calendar-entries.service";
import CalendarDataSourceMock from "./calendar-data-source.service.mock";
import {fakeResponse} from "../../services/http-mocking.service";
import CalendarEntryInterface from "../calendar-entry.interface";

describe("ThemisComponents: thScheduler : CalendarEntriesService", function() {
  let calendarEntryService: CalendarEntriesService;
  let calendarDataSourceMock: CalendarDataSourceMock;

  beforeEach(function() {
    calendarDataSourceMock = new CalendarDataSourceMock();
    calendarEntryService = new CalendarEntriesService(
      {
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
      },
      calendarDataSourceMock,
      {
        create: function() { return "api/v4/calendar_entries?fields=id,summary,start_at,end_at,location"; },
        read: function(id: number) {
          return `api/v4/calendar_entries?calendar_id=${id}&fields=id,summary,start_at,end_at,location`;
        },
        update: function(id: number) { return `api/v4/calendar_entries/${id}`; },
        delete: function(id: number) { return `api/v4/calendar_entries/${id}`; },
      },
    );
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

  describe("#createCalendarEntry", function() {

    it("creates a new entry for a calendar", function(done) {
      fakeResponse(/calendar_entries/, {data: expectedEntries.firstCalendarEntriesItems[0]}, "POST");
      calendarEntryService.createCalendarEntry(expectedEntries.firstCalendarEntriesItems[0])
        .then(function(response) {
          /**
           * We are creating a new resource here, which has an id of 0. When a server/fakeResponse library
           * receives that object, it will respond with the newly created resource - which has an updated id (not 0).
           * Therefore, to test this object, we need to grab the newly created id from the server response BEFORE
           * asserting the original object equals the new object.
           */
          expectedEntries.firstCalendarEntriesItems[0].id = response.data.id;
          expect(response.data).toEqual(expectedEntries.firstCalendarEntriesItems[0]);
          done();
        });
    });
  });

  describe("#updateCalendarEntry", function() {

    it("updates a given calendar entry", function(done) {
      // TODO: This should really use another interface that allows flexibility
      const updateData = { title: "NEW TITLE" } as CalendarEntryInterface;

      fakeResponse(/calendar_entries/, { data: updateData }, "PATCH");
      calendarEntryService.updateCalendarEntry(
        expectedEntries.firstCalendarEntriesItems[0].id,
        updateData,
      ).then(function(response) {
        expect(response.data.title).toEqual(updateData.title);
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
