import { AutocompleteConfiguration } from "../../providers/autocomplete.interface";
import ComboBoxAutocomplete from "../../providers/combo-box-autocomplete";

class ComboBoxAutocompleteMock extends ComboBoxAutocomplete {

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

export default ComboBoxAutocompleteMock;
