import { AutocompleteConfiguration } from "./autocomplete.interface";
import AutocompleteAbstract from "./autocomplete.abstract";
import "@progress/kendo-ui/js/kendo.autocomplete.js";

class Autocomplete extends AutocompleteAbstract {

  protected kendoComponent: kendo.ui.AutoComplete;

  constructor(protected config: AutocompleteConfiguration) {
    super(config);
  }

  protected validateOptions() {
    super.validateOptions();
    this.validateValueIsObject();
  }

  setInitialValue(): void {
    if (this.config.value) {
      this.initialValue = this.config.value[this.config.options.displayField];
    }
  }

  create() {
    let validSelection: boolean;

    const widgetOptions = {
      dataTextField: this.config.options.displayField,
      enable: this.enabled,
      filter: this.config.options.filter,
      dataSource: this.config.options.dataSource,
      minLength: this.config.options.minLength,
      placeholder: this.config.placeholder,
      noDataTemplate: this.config.options.noDataTemplate,
      template: this.config.options.rowTemplate,
      fixedGroupTemplate: "",
      open: function() {
        validSelection = false;
      },
      close: () => {
        if (!validSelection) {
          this.kendoComponent.value("");
        }
      },
      select: (e: kendo.ui.AutoCompleteSelectEvent) => {
        validSelection = true;
        if (e.dataItem) {
          this.config.change(e.dataItem);
        }
      },
      change: (component: kendo.ui.AutoCompleteChangeEvent) => {
        if (component.sender.value() === "") {
          this.config.change(component.sender.value(""));
        }
      },
    } as kendo.ui.AutoCompleteOptions;

    this.kendoComponent = new kendo.ui.AutoComplete(this.config.element, widgetOptions);
    this.kendoComponent.value(this.initialValue);
  }
}

export default Autocomplete;
