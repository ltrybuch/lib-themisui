import * as faker from "faker";
import * as moment from "moment";

const staticColumns = [
  {
    field: "FirstName",
    title: "First Name",
    minResizableWidth: 100,
  },
  {
    field: "LastName",
    title: "Last Name",
    minResizableWidth: 100,
  },
  {
    title: "Birthday",
    template: (dataItem: { [field: string]: string }) => moment(dataItem.Birthday).format("MM/DD/YYYY"),
    minResizableWidth: 80,
  },
  {
    field: "Salary",
    title: "Salary",
    minResizableWidth: 60,
  },
];

const remoteColumns = [
  {
    field: "id",
    title: "ID",
    width: "120px",
    minResizableWidth: 120,
  },
  {
    field: "full_name",
    title: "Full Name",
    minResizableWidth: 100,
  },
  {
    title: "Language",
    template: "#= language ? language : `-` #",
    width: "120px",
    minResizableWidth: 80,
  },
  {
    title: "URL",
    template: "<a href='#= html_url #' target='blank'>#= html_url #</a>",
  },
];

const fakeDataLength = 75;

let fakeDataArr = [];
for (let i = 0; i < fakeDataLength; i++) {
  fakeDataArr.push({
    id: i,
    FirstName: faker.name.firstName(),
    LastName: faker.name.lastName(),
    Birthday: moment(faker.date.past()).startOf("date").format(),
    Salary: parseInt(faker.finance.amount(75, 200), 10) * 1000,
  });
}

const fakeDataObj = {
  total: fakeDataLength,
  items: fakeDataArr,
};

export {
  staticColumns,
  remoteColumns,
  fakeDataObj,
};
