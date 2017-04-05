import { AutocompleteConfiguration } from "./autocomplete.interface";
import AutocompleteAbstract from "./autocomplete.abstract";
import { AutocompleteProviderError } from "../autocomplete.errors";
import "@progress/kendo-ui/js/kendo.multiselect.js";

class MultiSelectAutocomplete extends AutocompleteAbstract {
  protected kendoComponent: kendo.ui.MultiSelect;

  constructor(protected config: AutocompleteConfiguration) {
    super(config);
  }

  protected initializeOptions() {
    this.config.options.minLength = this.config.options.minLength || 1;
    super.initializeOptions();
  }

  protected validateOptions() {
    super.validateOptions();

    if (this.config.value && this.config.value instanceof Array === false) {
      throw new AutocompleteProviderError(`options.value. Value "${this.config.value}" should be an Array of IDs`);
    }
  }

  setInitialValue(): void {
    if (this.config.value) {
      this.initialValue = this.config.value;
    }
  }

  public setValue(theValue: any) {
    if (this.kendoComponent) {
      let newValue = theValue ? theValue : "";
      this.kendoComponent.value(newValue);
    }
  }

  create() {
    const widgetOptions = {
      autoBind: this.autoBind,
      dataTextField: this.config.options.displayField,
      dataValueField: this.config.options.trackField,
      enable: this.enabled,
      filter: this.config.options.filter,
      dataSource: this.config.options.dataSource,
      minLength: this.config.options.minLength,
      placeholder: this.config.placeholder,
      noDataTemplate: this.config.options.noDataTemplate,
      itemTemplate: this.config.options.rowTemplate,
      fixedGroupTemplate: "",
      change: (component: kendo.ui.MultiSelectChangeEvent) => {
        this.config.change(component.sender.value());
      },
    } as kendo.ui.MultiSelectOptions;

    this.kendoComponent = new kendo.ui.MultiSelect(this.config.element, widgetOptions);
    this.kendoComponent.value(this.initialValue);
  }
}

export default MultiSelectAutocomplete;
