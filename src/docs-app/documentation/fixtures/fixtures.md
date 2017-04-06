# Fixtures

## What are they about?

Throughout the tests and examples you will notice references to “fixture” files. These fixtures contain sample data that is used…

- to provide data to demos
- to stub response data when mocking HTTP responses (both in tests and demos)
- to stub objects in tests

and ultimately…

- as a centralized source of truth for stubbing

Stub data can be simplified as JSON, and we initially aimed to do just that. However a minimal amount of computation/manipulation was allowed to facilitate DRYing up of the objects.


## What they are not about

A fixture file shoud be EXTREMELY easy to understand…it should just represent some sample data. Getting fancy with computing values is to be avoided as much as possible. We don’t want fixture data to become an additional layer of complexity when working with the codebase. *As a hard rule:* Don’t put logic in fixture files. Favour duplication over introducing logic.

## Conventions

### No home for "Clio API" data
We've developed the belief that fixture data should not contain Clio API response objects, even if it makes it initially easier to "get going".

#### Why would I want to use Clio API response objects though?
If the component you are working with uses a Clio API response for its data, it is easy to copy the response body of the endpoint in question, straight into the fixture.

#### So I shouldn't do that?
It is discouraged. You can expect Code Reviews to fail on such practice. [Coupling](https://en.wikipedia.org/wiki/Coupling_(computer_programming)) is something we want to avoid; we don't want to slip into tying ThemisUI components to Clio.
If we allow Clio data structures to take root in ThemisUI, there is always the chance it could spread outside of "just for fixtures".

```javascript
// thScheduler/tests/fixtures/entries.ts

// bad
const items = [{
  id: 1,
  title: "My Clio Event", // Clio-related test data, not needed nor ideal
  matter: 82938,          // a Clio artifact, nothing to do with a generic thScheduler
  start_at: "2017/05/05", // start_at is coupled to the Clio CalendarEntry data structure
  end_at: "2017/05/06",   // end_at is coupled to the Clio CalendarEntry data structure
}]

// good
const items = [{
  id: 1,
  title: "My Cool Event", // No need for this to be Clio-related, so it isn't
                          // "matter" is nothing to do with a generic thScheduler
  start: "2017/05/05",    // Using a simple key, choosing not to couple to Clio key
  end: "2017/05/06",      // Using a simple key, choosing not to couple to Clio key
}]
```

### Where do they live?

In one place, per component: `myComponent/tests/fixtures`

There should be one fixture file per resource e.g. `entries.ts`, `calendars.ts`.

#### `items`

A standardized name, rather than naming items by their nature e.g. `calendars`.

```javascript
import * as expectedEntries from "./tests/fixtures/entries";
import * as expectedEntries from "./tests/fixtures/calendars";

// bad
expectedEntries.entries
expectedCalendars.calendars

// good
expectedEntries.items
expectedCalendars.items
```

#### `ids`

Almost always required when the retrieval of ids is needed for corresponding resources.

      describe("#getCalendarIds", function() {

        it("returns the calendar ids", function(done) {
          calendarEntryService.getCalendarIds()
            .then(function(data) {
              expect(data).toEqual(expectedCalendars.ids);
              done();
            });
        });

      });


#### `apiNestedItems`

Nests the `items` to mimic an API response whose data is nested. It is useful to encapsulate this modification inside this file, to keep it out of the implementation.

```javascript
const apiNestedItems = {
  calendars: items
};
```

## Example “Calendars” fixture

```javascript
const items = [
  {
    id: 1,
    name: "Personal"
  },
  {
    id: 2,
    name: "Shared"
  }
];

const ids = [1, 2];

const apiNestedItems = {
  calendars: items
};

export {
  items,
  ids,
  apiNestedItems
};
```

### Usage

```javascript
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

import * as angular from "angular";
import { fakeResponse } from "../../../services/http-mocking.service";
import * as expectedEntries from "../../tests/fixtures/entries";
import * as expectedCalendars from "../../tests/fixtures/calendars";
import SchedulerDataSource from "../../../services/scheduler-data-source.service";
import CalendarEntriesService from "../../multipleCalendars/calendar-entries.service";

fakeResponse(/calendars/, expectedCalendars.apiNestedItems);
fakeResponse(/calendar_entries\?calendar_id\=1/, expectedEntries.firstCalendarEntriesItems);
fakeResponse(/calendar_entries\?calendar_id\=2/, expectedEntries.secondCalendarEntriesItems);

angular.module("thSchedulerDemo")
  .controller("thSchedulerDemoCtrl3", function(
    SchedulerDataSource: SchedulerDataSource,
    CalendarEntriesService: CalendarEntriesService
  ) {

    this.options = {
      dataSource: SchedulerDataSource.createDataSource({
        schema: {
          data: "entries",
          model: {
            fields: {
              end: { from: "end", type: "date" },
              id: { from: "id", type: "number" },
              start: { from: "start", type: "date" },
              title: { from: "title" },
              calendar_id: { from: "calendar_id" }
            },
            id: "id"
          }
        },
        transport: {
          read: function(e: kendo.data.DataSourceTransportOptions) {
            CalendarEntriesService.getEntriesForCalendars()
              .then(function(entries) {
                e.success({ entries: entries });
              });
          }
        }
      }),
      date: new Date(expectedEntries.date)
    };
  });
```
