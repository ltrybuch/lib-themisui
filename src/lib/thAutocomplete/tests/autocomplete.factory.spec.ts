import { AutocompleteFactory } from "../autocomplete.factory";
import { AutocompleteOptionsTestFixture } from "./fixtures/autocomplete-opts-test-fixture";
import { Autocomplete } from "../providers/autocomplete";
import { ComboBoxAutocomplete } from "../providers/combo-box-autocomplete";
import { MultiSelectAutocomplete } from "../providers/multi-select-autocomplete";

let context = describe;

describe("ThemisComponents: Factory: AutocompleteFactory", () => {

  describe("#createAutocomplete", () => {

    context("with valid options", () => {
      it("should return type Autocomplete as a default", () => {
        const opts = AutocompleteOptionsTestFixture.createAutocompleteOptions();
        const autocomplete = AutocompleteFactory.createAutocomplete(opts);
        expect(autocomplete instanceof Autocomplete).toBe(true);
      });

      it("should return type ComboBoxAutocomplete", () => {
        const opts = AutocompleteOptionsTestFixture.createAutocompleteOptions();
        opts.combobox = true;
        const autocomplete = AutocompleteFactory.createAutocomplete(opts);
        expect(autocomplete instanceof ComboBoxAutocomplete).toBe(true);
      });

      it("should return type MultiSelectAutocomplete", () => {
        const opts = AutocompleteOptionsTestFixture.createAutocompleteOptions();
        opts.multiple = true;
        const autocomplete = AutocompleteFactory.createAutocomplete(opts);
        expect(autocomplete instanceof MultiSelectAutocomplete).toBe(true);
      });
    });
  });
});
