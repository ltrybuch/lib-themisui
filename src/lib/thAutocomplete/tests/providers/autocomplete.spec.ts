import AutocompleteMock from "../mocks/autocomplete.mock";
import {AutocompleteConfiguration} from "../../providers/autocomplete.interface";
import AutocompleteOptionsFixture from "../fixtures/autocomplete-opts.fixture";
import { AutocompleteProviderError } from "../../autocomplete.errors";

describe("ThemisComponents: thAutocomplete : Autocomplete", () => {

  describe("Validations", () => {
    let config: AutocompleteConfiguration;

    it("should throw an error when the initial value is not an object", () => {
      expect(function() {
        config = AutocompleteOptionsFixture.createAutocompleteConfig();
        config.value = "I should break";
        new AutocompleteMock(config);
      }).toThrow(
        new AutocompleteProviderError(`options.value invalid. Value "I should break" should be an object`),
      );

    });
  });

  describe("Initialize Options", () => {

    let autocomplete: AutocompleteMock;
    let config: AutocompleteConfiguration;
    beforeEach(() => {
      autocomplete = undefined;
      config = AutocompleteOptionsFixture.createAutocompleteConfig();
    });

    it("sets initialValue to displayField value from supplied value object", () => {
      let expectedValue = {id: 1, name: "Stanley"};
      config.value = expectedValue;

      autocomplete = new AutocompleteMock(config);

      expect(autocomplete.getInitialValue()).toEqual(expectedValue.name);
    });

  });

});
