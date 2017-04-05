import { AutocompleteConfiguration } from "../../providers/autocomplete.interface";
import AutocompleteAbstract from "../../providers/autocomplete.abstract";

class AutocompleteAbstractMock extends AutocompleteAbstract {

  constructor(protected config: AutocompleteConfiguration) {
    super(config);
  }

  create() {
    this.kendoComponent = new kendo.ui.AutoComplete(this.config.element, {});
  }

  getInternalConfig() {
    return this.config;
  }

  getFilter() {
    return this.config.options.filter;
  }

  getInitialValue() {
    return this.initialValue;
  }

  setInitialValue(): void {
    this.initialValue = null;
  }

  getValue() {
    return this.kendoComponent.value();
  }

  getAutoBind() {
    return this.autoBind;
  }

  getKendoComponent() {
    return this.kendoComponent;
  }
}

export default AutocompleteAbstractMock;
