const firstItemId = 1;

const firstItemColor = "#CCCCCC";

const items = [
  {
    id: firstItemId,
    name: "Personal",
    visible: false,
    color: firstItemColor,
  },
  {
    id: 2,
    name: "Shared",
    visible: true,
    color: "#000000",
  },
];

const ids = [firstItemId, 2];

const apiNestedItems = {
  data: items,
};

const apiNestedItem = {
  data: items[0],
};

const apiNestedFirstItem = {
  data: items[0],
};

const apiNestedSecondItem = {
  data: items[1],
};

export {
  items,
  ids,
  firstItemId,
  firstItemColor,
  apiNestedItems,
  apiNestedItem,
  apiNestedFirstItem,
  apiNestedSecondItem
};
