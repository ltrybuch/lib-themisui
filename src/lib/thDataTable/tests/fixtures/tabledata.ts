import * as faker from "faker";

const staticColumns = [
  {
    field: "FirstName",
    title: "First Name",
  },
  {
    field: "LastName",
    title: "Last Name",
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
