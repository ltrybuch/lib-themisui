import { AutocompleteOptions } from "./autocomplete-options.interface";
import { AbstractAutocomplete } from "./autocomplete.abstract";
import "@progress/kendo-ui/js/kendo.autocomplete.js";

export class Autocomplete extends AbstractAutocomplete {
  protected kendoComponent: kendo.ui.AutoComplete;

  constructor(protected options: AutocompleteOptions) {
    super(options);
  }

  protected initializeOptions() {
    super.initializeOptions();
  }

  create() {
    const widgetOptions = {
      dataTextField: this.options.delegate.displayField,
      enable: this.enabled,
      filter: this.filterType,
      dataSource: this.options.delegate.dataSource,
      minLength: this.options.delegate.minLength ? this.options.delegate.minLength : 2,
      placeholder: this.options.placeholder,
      value: this.initialValue,
      noDataTemplate: this.noDataTemplate,
      template: this.options.rowTemplate,
      fixedGroupTemplate: "",
      popup: {
        appendTo: this.options.parentElement
      },
      close: function(e: any) {
        // Clear autocomplete and combobox inputs on
        // blur if value is not a valid selection
        let dataItem = this.dataItem(e.item);
        if (!dataItem) {
          $(this.element).val("");
        }
      },
      select: (e: any) => {
        if (e.dataItem) {
          this.options.change(e.dataItem);
        }
      },
      change: (component: any) => {
        if (component.sender.value() === "") {
          this.options.change(component.sender.value());
        }
      }
    } as kendo.ui.AutoCompleteOptions;

    this.kendoComponent = new kendo.ui.AutoComplete(this.options["element"], widgetOptions);
  }
}
