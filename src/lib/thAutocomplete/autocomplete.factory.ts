import AutocompleteAbstract from "./providers/autocomplete.abstract";
import Autocomplete from "./providers/autocomplete";
import ComboBoxAutocomplete from "./providers/combo-box-autocomplete";
import MultiSelectAutocomplete from "./providers/multi-select-autocomplete";
import { AutocompleteConfiguration, AutocompleteType } from "./providers/autocomplete.interface";

export default class AutocompleteFactory {
  public static createAutocomplete(type: AutocompleteType, config: AutocompleteConfiguration): AutocompleteAbstract {
    if (type === "combobox") {
        return new ComboBoxAutocomplete(config);
    } else if (type === "multiple") {
        return new MultiSelectAutocomplete(config);
    } else {
        return new Autocomplete(config);
    }
  }
}
