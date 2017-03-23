import * as $ from "jquery";
import { AutocompleteOptions } from "./autocomplete-options.interface";
import "@progress/kendo-ui/js/kendo.validator.js";

abstract class AbstractAutocomplete {
  protected enabled: boolean = true;
  protected filterType: string = "startswith";
  protected initialValue: any;
  protected autoBind: boolean = false;

  // TODO: #i18n
  protected noDataTemplate: string = "No results.";
  protected kendoComponent: any;

  constructor(protected options: AutocompleteOptions) {
    this.initializeOptions();
    this.create();
  }

  protected initializeOptions() {
    if (this.options.ngDisabled) {
      this.enabled = false;
    }

    if (this.options.delegate.filterType) {
      this.filterType = this.options.delegate.filterType;
    }

    this.initialValue = this.options.value;
    if (this.options.value instanceof Object) {
      this.initialValue = this.options.value[this.options.delegate.displayField];
    }

    if (this.options.delegate.autoBind) {
      this.autoBind = true;
    }
  }

  get isEnabled(): boolean {
    return this.enabled;
  }

  public setValue(theValue: any) {
    if (this.kendoComponent) {
      let newValue = theValue ? theValue : "";
      if (theValue instanceof Object) {
        newValue = theValue[this.options.delegate.displayField];
      }
      this.kendoComponent.value(newValue);
    }
  }

  abstract create(): void;

  public toggleEnabled() {
    this.enabled = !this.enabled;
    if (this.kendoComponent) {
      this.kendoComponent.enable(this.enabled);
    }
  }

  public toggleRequired() {
    let validator = $(this.kendoComponent.element[0].form).kendoValidator().data("kendoValidator");

    if (this.options.element.required === true) {
      this.options.element.removeAttribute("required");
    } else {
      this.options.element.setAttribute("required", "required");
    }
    validator.validateInput(this.options.element);
  }

  public toggleSearchHint(showHint: boolean) {
    if (this.kendoComponent) {
      let list = this.kendoComponent.list;

      if (showHint === true) {
        // TODO: #i18n
        $(list).append(`<span class="search-hint">Type to find more results</span>`);
      } else {
        $(list).find(".search-hint").remove();
      }
    }
  }
 }

export {
  AbstractAutocomplete
}
