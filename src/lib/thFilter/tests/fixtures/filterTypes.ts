import * as faker from "faker";

const items = [
  {
    name: "Tier",
    type: "select",
    fieldIdentifier: "tier",
    placeholder: "Select an option",
    selectOptions: [
      {name: "One", value: "one"},
      {name: "Two", value: "two"},
      {name: "Three", value: "three"},
    ],
  },
  {
    name: "Difficulty",
    type: "select",
    fieldIdentifier: "difficulty",
    placeholder: "Select an option",
    selectOptions: [
      {name: "Easy", value: "easy"},
      {name: "Medium", value: "medium"},
      {name: "Hard", value: "hard"},
    ],
  },
  {
    name: "Status",
    type: "select",
    fieldIdentifier: "status",
    placeholder: "Select an option",
    selectOptions: [
      {name: "Open", value: "open"},
      {name: "Closed", value: "closed"},
      {name: "Pending", value: "pending"},
    ],
  },
];

/**
 * TODO: Move these tableHeaders into another fixture-related file.
 * Why? Because tableHeaders are a thTable concept, nothing to do
 * with filterTypes themselves.
 */
const headers = (() => {
  let headers: any = [
    {
      name: "Id",
      sortField: "id",
      width: "100px",
    },
    {
      name: "Name",
      sortField: "name",
      sortActive: true,
    },
  ];

  items.forEach(item => {
    headers.push({
      name: item.name,
      sortField: item.fieldIdentifier,
    });
  });

  return headers;
})();

const data = (length: number) => {
  let rows = [];

  for (let i = 0; i < length; i++) {
    rows.push({
      id: i,
      name: faker.name.lastName(),
      tier: faker.helpers.randomize(["one", "two", "three"]),
      difficulty: faker.helpers.randomize(["easy", "medium", "hard"]),
      status: faker.helpers.randomize(["open", "closed", "pending"]),
    });
  }

  return rows;
};

const lotsOfTypes = (length: number) => {
  let types = [];

  for (let i = 0; i < length; i++) {
    const word = faker.lorem.word();
    const word2 = faker.lorem.word();
    const word3 = faker.lorem.word();
    const word4 = faker.lorem.word();

    types.push({
      name: word,
      // tslint:disable-next-line:max-line-length
      type: faker.helpers.randomize(["select", "input", "number", "currency", "checkbox", "url", "email", "date"]),
      fieldIdentifier: word.toLowerCase(),
      placeholder: "Select an option",
      selectOptions: [
        {name: word2, value: word2.toLowerCase()},
        {name: word3, value: word3.toLowerCase()},
        {name: word4, value: word4.toLowerCase()},
      ],
    });
  }

  types[length - 1].name = "Doob";

  return types;
};

export {
  items,
  headers,
  data,
  lotsOfTypes
}
