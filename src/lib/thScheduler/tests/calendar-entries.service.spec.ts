import * as angular from "angular";
import * as expectedCalendars from "./fixtures/calendars";
import * as expectedEntries from "./fixtures/entries";
import CalendarEntriesService from "../multipleCalendars/calendar-entries.service";
import CalendarDataSourceMock from "../calendar-data-source.service.mock";

describe("ThemisComponents: thScheduler : CalendarEntriesService", function() {

  let calendarEntryService: CalendarEntriesService;
  let $http: angular.IHttpService;
  let $httpBackend: angular.IHttpBackendService;

  beforeEach(angular.mock.module("ThemisComponents"));

  beforeEach(inject(function(
    _$http_: angular.IHttpService,
    _$httpBackend_: angular.IHttpBackendService
    ) {
      $http = _$http_;
      $httpBackend = _$httpBackend_;
    })
  );

  beforeEach(function() {
    calendarEntryService = new CalendarEntriesService($http);
    calendarEntryService.calendarDataSource = new CalendarDataSourceMock();
  });

  describe("#getCalendarIds", function() {

    it("returns the calendar ids", function(done) {
      calendarEntryService.getCalendarIds()
        .then(function(data) {
          expect(data).toEqual(expectedCalendars.ids);
          done();
        });
    });

  });

  describe("#getEntriesForCalendar", function() {

    it("returns the entries for one calendar", function(done) {
      calendarEntryService.getEntriesForCalendar(expectedEntries.oneCalendarEntriesId)
        .then(function(data) {
          expect(data).toEqual(expectedEntries.oneCalendarEntriesItems);
          done();
        });

      $httpBackend
        .expectGET("calendar_entries?calendar_id=1")
        .respond(expectedEntries.oneCalendarEntriesItems);
      $httpBackend.flush();
    });

  });

  describe("#getEntriesForCalendars", function() {

    it("returns entries for two calendars", function(done) {
      calendarEntryService.getEntriesForCalendars()
        .then(function(data) {
          expect(data).toEqual(expectedEntries.items);
          done();
        });

      $httpBackend
        .expectGET("calendar_entries?calendar_id=1")
        .respond(expectedEntries.firstCalendarEntriesItems);

      $httpBackend
        .expectGET("calendar_entries?calendar_id=2")
        .respond(expectedEntries.secondCalendarEntriesItems);

      setTimeout(() => $httpBackend.flush());
    });

  });

});
