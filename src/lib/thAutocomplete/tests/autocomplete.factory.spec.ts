import AutocompleteFactory from "../autocomplete.factory";
import AutocompleteOptionsFixture from "./fixtures/autocomplete-opts.fixture";
import Autocomplete from "../providers/autocomplete";
import ComboBoxAutocomplete from "../providers/combo-box-autocomplete";
import MultiSelectAutocomplete from "../providers/multi-select-autocomplete";


describe("ThemisComponents: thAutocomplete : AutocompleteFactory", () => {

  describe("#createAutocomplete", () => {

    it("should return type Autocomplete as a default", () => {
      const opts = AutocompleteOptionsFixture.createAutocompleteConfig();
      const autocomplete = AutocompleteFactory.createAutocomplete("autocomplete", opts);
      expect(autocomplete instanceof Autocomplete).toBe(true);
    });

    it("should return type ComboBoxAutocomplete", () => {
      const opts = AutocompleteOptionsFixture.createAutocompleteConfig();
      const autocomplete = AutocompleteFactory.createAutocomplete("combobox", opts);
      expect(autocomplete instanceof ComboBoxAutocomplete).toBe(true);
    });

    it("should return type MultiSelectAutocomplete", () => {
      const opts = AutocompleteOptionsFixture.createMultiSelectConfig();
      const autocomplete = AutocompleteFactory.createAutocomplete("multiple", opts);
      expect(autocomplete instanceof MultiSelectAutocomplete).toBe(true);
    });

  });

});
