import { AutocompleteConfiguration, AutocompleteDataOptions} from "../../providers/autocomplete.interface";

export default class AutocompleteOptionsFixture {
  public static createAutocompleteConfig(): AutocompleteConfiguration {

    const dataOptions: AutocompleteDataOptions = {
      displayField: "name",
      trackField: "id",
      dataSource: new kendo.data.DataSource({
        data: [
          {
            id: 1, name: "Bob",
          },
          {
            id: 2, name: "Gerry",
          },
        ],
      }),
    };

    let mockOptions: AutocompleteConfiguration = {
      element: "<input>",
      options: dataOptions,
      placeholder: "Type a foo...",
      value: { id: 2, name: "Jack Newton" },
      ngDisabled: false,
      ngRequired: false,
      change: (): undefined => undefined,
    };

    return mockOptions;
  }

  public static createMultiSelectConfig(): AutocompleteConfiguration {
    const config = AutocompleteOptionsFixture.createAutocompleteConfig();
    config.value = [1, 5, 8];
    return config;
  }
}
