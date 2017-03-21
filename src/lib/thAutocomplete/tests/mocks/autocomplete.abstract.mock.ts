import { AbstractAutocomplete } from "../../providers/autocomplete.abstract";

export class AbstractAutocompleteMock extends AbstractAutocomplete {
  constructor(protected options: any) {
    super(options);
  }

  create() {
    this.kendoComponent = new kendo.ui.AutoComplete(this.options["element"], {});
  }

  getInternalOptions() {
    return this.options;
  }

  getFilterType() {
    return this.filterType;
  }

  getInitialValue() {
    return this.initialValue;
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
