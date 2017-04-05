import ComboboxAutocompleteMock from "../mocks/combo-box-autocomplete.mock";
import {AutocompleteConfiguration} from "../../providers/autocomplete.interface";
import AutocompleteOptionsFixture from "../fixtures/autocomplete-opts.fixture";
import { AutocompleteProviderError } from "../../autocomplete.errors";

describe("ThemisComponents: thAutocomplete : Combobox", () => {

  describe("Validations", () => {
   it("should throw an error when the initial value is not an object", () => {
      let config: AutocompleteConfiguration;

      expect(function() {
        config = AutocompleteOptionsFixture.createAutocompleteConfig();
        config.value = "I should break";
        new ComboboxAutocompleteMock(config);
      }).toThrow(
        new AutocompleteProviderError(`options.value invalid. Value "I should break" should be an object`),
      );
    });
  });

  describe("Initialize Options", () => {
    let combobox: ComboboxAutocompleteMock;
    let config: AutocompleteConfiguration;
    beforeEach(() => {
      combobox = undefined;
      config = AutocompleteOptionsFixture.createAutocompleteConfig();
    });

    it("sets initialValue to displayField value from supplied value object", () => {
      const expectedValue = {id: 1, name: "Stanley"};
      config.value = expectedValue;

      combobox = new ComboboxAutocompleteMock(config);

      expect(combobox.getInitialValue()).toEqual(expectedValue.name);
    });

    describe("autoBind", () => {

      it("sets autoBind to true by default", () => {
        delete config.options.autoBind;
        combobox = new ComboboxAutocompleteMock(config);

        expect(combobox.getAutoBindValue()).toEqual(true);
      });

      it("sets autoBind to false if overridden by the config.options.autoBind", () => {
        config.options.autoBind = false;
        combobox = new ComboboxAutocompleteMock(config);

        expect(combobox.getAutoBindValue()).toEqual(false);
      });

    });

  });

});
