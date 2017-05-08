import { fakeDataObj as expectedDataObj } from "../../tests/fixtures/tabledata";

const staticFilters = [
  {
    name: "Name",
    type: "select",
    fieldIdentifier: "id",
    placeholder: "Select a user",
    selectOptions: expectedDataObj.items.map(item => {
      return {
        name: `${item.FirstName} ${item.LastName}`,
        value: item.id,
      };
    }),
  },
];

const customFilterTypes = [
  {
    name: "Birthday",
    type: "date",
    fieldIdentifier: "Birthday",
  },
  {
    name: "Salary",
    type: "currency",
    fieldIdentifier: "Salary",
  },
];

export { staticFilters, customFilterTypes };
