import { AbstractAutocomplete } from "./providers/autocomplete.abstract";
import { Autocomplete } from "./providers/autocomplete";
import { ComboBoxAutocomplete } from "./providers/combo-box-autocomplete";
import { MultiSelectAutocomplete } from "./providers/multi-select-autocomplete";
import { AutocompleteOptions } from "./providers/autocomplete-options.interface";

export class AutocompleteFactory {
  public static createAutocomplete(options: AutocompleteOptions): AbstractAutocomplete {
    if (options.combobox) {
        return new ComboBoxAutocomplete(options);
    } else if (options.multiple) {
        return new MultiSelectAutocomplete(options);
    } else {
        return new Autocomplete(options);
    }
  }
}
