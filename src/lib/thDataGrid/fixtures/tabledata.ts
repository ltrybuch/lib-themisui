const staticColumns = [
  {
    field: "FirstName",
    title: "First Name"
  },
  {
    field: "LastName",
    title: "Last Name"
  }
];

const staticData = [
  {
    id: 1,
    FirstName: "Chris",
    LastName: "Saunders"
  },
  {
    id: 2,
    FirstName: "Craig",
    LastName: "Carlyle"
  },
  {
    id: 3,
    FirstName: "Dwight",
    LastName: "Tomalty"
  },
  {
    id: 4,
    FirstName: "Frankie",
    LastName: "Yan"
  },
  {
    id: 5,
    FirstName: "Jef",
    LastName: "Curtis"
  },
  {
    id: 6,
    FirstName: "Jeff",
    LastName: "Marvin"
  },
  {
    id: 7,
    FirstName: "John",
    LastName: "Brennan"
  },
  {
    id: 8,
    FirstName: "Lucia",
    LastName: "Lu"
  },
  {
    id: 9,
    FirstName: "Mike",
    LastName: "Buckley"
  },
  {
    id: 10,
    FirstName: "Terry",
    LastName: "White"
  }
];

const remoteColumns = [
  {
    field: "id",
    title: "ID",
    width: "120px"
  },
  {
    field: "full_name",
    title: "Full Name"
  },
  {
    title: "Language",
    template: "#= language ? language : `-` #",
    width: "120px"
  },
  {
    title: "URL",
    template: "<a href='#= html_url #' target='blank'>#= html_url #</a>"
  }
];

export {
  staticColumns,
  staticData,
  remoteColumns
};
