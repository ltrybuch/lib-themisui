import { AutocompleteConfiguration } from "../../providers/autocomplete.interface";
import Autocomplete from "../../providers/autocomplete";

class AutocompleteMock extends Autocomplete {

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
}

export default AutocompleteMock;
