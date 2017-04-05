import { AutocompleteConfiguration } from "./autocomplete.interface";
import AutocompleteAbstract from "./autocomplete.abstract";
import "@progress/kendo-ui/js/kendo.combobox.js";

class ComboBoxAutocomplete extends AutocompleteAbstract {
  protected kendoComponent: kendo.ui.ComboBox;

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
      template: this.config.options.rowTemplate,
      fixedGroupTemplate: "",
      select: (e: kendo.ui.ComboBoxSelectEvent) => {
        if (e.dataItem) {
          this.config.change(e.dataItem);
        }
      },
      change: (component: kendo.ui.ComboBoxChangeEvent) => {
        if (component.sender.value() === "" || component.sender.value() &&
           (component.sender as any).selectedIndex === -1) {
          this.config.change(component.sender.value(""));
        }
      },
    } as kendo.ui.ComboBoxOptions;

    this.kendoComponent = new kendo.ui.ComboBox(this.config.element, widgetOptions);
    this.kendoComponent.value(this.initialValue);
  }
}

export default ComboBoxAutocomplete;
