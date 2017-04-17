import * as $ from "jquery";
import { AutocompleteConfiguration } from "./autocomplete.interface";
import { AutocompleteProviderError } from "../autocomplete.errors";


abstract class AutocompleteAbstract {
  protected enabled: boolean = true;
  protected initialValue: any;
  protected autoBind: boolean = true;
  protected kendoComponent: any;
  protected validator: kendo.ui.Validator;

  constructor(protected config: AutocompleteConfiguration) {
    this.initializeOptions();
    this.create();
  }

  protected validateOptions() {
    if (!this.config.options) {
      throw new AutocompleteProviderError(`You must provide the "options" parameter.`);
    }

    if (!this.config.options.displayField) {
      throw new AutocompleteProviderError("options.displayField is required");
    }
  }

  protected validateValueIsObject() {
    if (this.config.value && this.config.value instanceof Object === false) {
      throw new AutocompleteProviderError(`options.value invalid. Value "${this.config.value}" should be an object`);
    }
  }

  protected initializeOptions() {
    this.validateOptions();

    if (this.config.ngDisabled) {
      this.enabled = false;
    }

    if (this.config.options.hasOwnProperty("autoBind") && this.config.options.autoBind === false) {
      this.autoBind = false;
    }

    this.config.options.filter = this.config.options.filter || "startswith";
    this.config.options.trackField = this.config.options.trackField || "id";
    this.config.options.noDataTemplate = this.config.options.noDataTemplate ||  "No results.";
    this.config.options.minLength = this.config.options.minLength || 2;

    this.setInitialValue();

    if (this.config.options.groupBy) {
      this.config.options.dataSource.group({field: this.config.options.groupBy});
    }
  }

  get isEnabled(): boolean {
    return this.enabled;
  }

  public setValue(theValue: any) {
    if (this.kendoComponent) {
      let newValue = theValue ? theValue[this.config.options.displayField] : "";
      this.kendoComponent.value(newValue);
    }
  }

  abstract create(): void;

  abstract setInitialValue(): void;

  public toggleEnabled() {
    this.enabled = !this.enabled;
    if (this.kendoComponent) {
      this.kendoComponent.enable(this.enabled);
    }
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

export default AutocompleteAbstract;
