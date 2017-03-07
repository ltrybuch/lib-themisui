import { AutocompleteOptions } from "./autocomplete-options.interface";
import { AbstractAutocomplete } from "./autocomplete.abstract";
import "@progress/kendo-ui/js/kendo.combobox.js";

export class ComboBoxAutocomplete extends AbstractAutocomplete {
  protected kendoComponent: kendo.ui.ComboBox;

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
      template: this.options.rowTemplate,
      fixedGroupTemplate: "",
      popup: {
        appendTo: this.options.parentElement
      },
      close: function(e: any) {
        // clear inputs on blur if value is not a valid selection
        let dataItem = this.dataItem(e.item);
        if (!dataItem) {
          $(e.sender.input).val("");
        }
      },
      select: (e: any) => {
        if (e.item) {
          let dataItem = this.kendoComponent.dataItem(e.item.index());
          this.options.change(dataItem);
        }
      },
      change: (component: any) => {
        if (this.options.multiple || component.sender.value() === "") {
          this.options.change(component.sender.value());
        }
        if (this.options["ngChange"]) {
          this.options["ngChange"]();
        }
      }
    } as kendo.ui.ComboBoxOptions;

    this.kendoComponent = new kendo.ui.ComboBox(this.options["element"], widgetOptions);
  }
}
