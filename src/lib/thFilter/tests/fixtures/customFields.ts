const items = [
  {
    "name": "checkbox",
    "field_type": "checkbox",
    "id": "0",
  },
  {
    "name": "autocomplete",
    "field_type": "autocomplete",
    "id": "1",
    "autocomplete_options": {
      "model_class": "Repo2",
      "display_field": "full_name",
    },
  },
  {
    "name": "autocomplete with rowTemplate",
    "field_type": "autocomplete",
    "id": "1",
    "autocomplete_options": {
      "model_class": "Repo2",
      "display_field": "full_name",
      "row_template": `
        <span class="k-state-default">#: data.full_name #, <strong>Forks</strong>: #: data.forks #</span>
      `,
    },
  },
  {
    "name": "date",
    "field_type": "date",
    "id": "2",
  },
  {
    "name": "email",
    "field_type": "email",
    "id": "3",
  },
  {
    "name": "numeric",
    "field_type": "numeric",
    "id": "4",
  },
  {
    "name": "currency",
    "field_type": "currency",
    "id": "6",
  },
  {
    "name": "picklist",
    "field_type": "picklist",
    "id": "7",
    "custom_field_picklist_options":
    [
      {
        "option": "picklist_option1",
        "id": "0",
      },
      {
        "option": "picklist_option2",
        "id": "1",
      },
    ],
  },
  {
    "name": "text_area",
    "field_type": "text_area",
    "id": "8",
  },
  {
    "name": "text_line",
    "field_type": "text_line",
    "id": "9",
  },
  {
    "name": "time",
    "field_type": "time",
    "id": "10",
  },
  {
    "name": "url",
    "field_type": "url",
    "id": "11",
  },
];

const filteredItems = items.slice(0, 3);

export {
  items,
  filteredItems,
};
