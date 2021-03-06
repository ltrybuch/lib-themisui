const date = "2017/02/20";
const firstCalendarEntriesItems = [
  {
    id: 1,
    calendar_id: 1,
    start: "2017-02-20T09:20:00-08:00",
    end: "2017-02-20T10:20:00-08:00",
    title: "Brunch with Giles",
  },
  {
    id: 2,
    calendar_id: 1,
    start: "2017-02-20T15:20:00-08:00",
    end: "2017-02-20T17:20:00-08:00",
    title: "Saunter around the grounds",
  },
];

const secondCalendarEntriesItems = [
  {
    id: 3,
    calendar_id: 2,
    start: "2017-02-20T04:20:00-08:00",
    end: "2017-02-20T05:20:00-08:00",
    title: "Pick wild berries",
  },
  {
    id: 4,
    calendar_id: 2,
    start: "2017-02-20T02:20:00-08:00",
    end: "2017-02-20T03:20:00-08:00",
    title: "Write poetry",
  },
];

const items = [...firstCalendarEntriesItems, ...secondCalendarEntriesItems];

const oneCalendarEntriesId = firstCalendarEntriesItems[0].calendar_id;

const apiNestedItems = {
  data: items,
};

const apiNestedOneCalendarEntriesItems = {
  data: firstCalendarEntriesItems,
};

const apiNestedSecondCalendarEntriesItems = {
  data: secondCalendarEntriesItems,
};

export {
  date,
  items,
  firstCalendarEntriesItems as oneCalendarEntriesItems,
  oneCalendarEntriesId,
  firstCalendarEntriesItems,
  secondCalendarEntriesItems,
  apiNestedItems,
  apiNestedOneCalendarEntriesItems,
  apiNestedSecondCalendarEntriesItems,
};
