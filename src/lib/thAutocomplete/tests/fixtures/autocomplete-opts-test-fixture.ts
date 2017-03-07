import { AutocompleteOptions, Delegate } from "../../providers/autocomplete-options.interface";

export class AutocompleteOptionsTestFixture {
  public static createAutocompleteOptions(): AutocompleteOptions {

    let delegate: Delegate = {
      displayField: "name",
      trackField: "id",
      dataSource: new kendo.data.DataSource({})
    };

    let mockOptions: AutocompleteOptions = {
      element: "<input>",
      parentElement: "<div></div>",
      delegate: delegate,
      placeholder: "Type a foo...",
      value: null,
      ngChange: null,
      ngDisabled: false,
      ngRequired: false,
      combobox: false,
      multiple: false,
      change: () => {}
    };

    return mockOptions;
  }
}
