import { AutocompleteOptions } from "./autocomplete-options.interface";
import { AbstractAutocomplete } from "./autocomplete.abstract";
import "@progress/kendo-ui/js/kendo.multiselect.js";

export class MultiSelectAutocomplete extends AbstractAutocomplete {
  protected kendoComponent: kendo.ui.MultiSelect;

  constructor(protected options: AutocompleteOptions) {
    super(options);
  }

  create() {
    const widgetOptions = {
      autoBind: this.autoBind,
      dataTextField: this.options.delegate.displayField,
      dataValueField: this.options.delegate.trackField,
      enable: this.enabled,
      filter: this.filterType,
      dataSource: this.options.delegate.dataSource,
      minLength: this.options.delegate.minLength ? this.options.delegate.minLength : 2,
      placeholder: this.options.placeholder,
      value: this.initialValue,
      noDataTemplate: this.noDataTemplate,
      itemTemplate: this.options.rowTemplate,
      fixedGroupTemplate: "",
      popup: {
        appendTo: this.options.parentElement,
      },
      change: (component: any) => {
        if (this.options.multiple || component.sender.value() === "") {
          this.options.change(component.sender.value());
        }
      },
    } as kendo.ui.MultiSelectOptions;

    this.kendoComponent = new kendo.ui.MultiSelect(this.options.element, widgetOptions);
  }
}
