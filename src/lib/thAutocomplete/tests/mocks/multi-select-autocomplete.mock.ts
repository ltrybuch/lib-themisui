import { AutocompleteConfiguration } from "../../providers/autocomplete.interface";
import MultiSelectAutocomplete from "../../providers/multi-select-autocomplete";

class MultiSelectAutocompleteMock extends MultiSelectAutocomplete {

  constructor(protected config: AutocompleteConfiguration) {
    super(config);
  }

  getInternalConfig() {
    return this.config;
  }

  getInitialValue() {
    return this.initialValue;
  }

  getKendoComponent() {
    return this.kendoComponent;
  }

  getAutoBindValue() {
    return this.autoBind;
  }
}

export default MultiSelectAutocompleteMock;
