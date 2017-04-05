import MultiSelectAutocompleteMock from "../mocks/multi-select-autocomplete.mock";
import {AutocompleteConfiguration} from "../../providers/autocomplete.interface";
import AutocompleteOptionsFixture from "../fixtures/autocomplete-opts.fixture";
import { AutocompleteProviderError } from "../../autocomplete.errors";

describe("ThemisComponents: thAutocomplete : Multiselect", () => {

  describe("Validations", () => {
   it("should throw an error when the initial value is not an object", () => {
      let config: AutocompleteConfiguration;

      expect(function() {
        config = AutocompleteOptionsFixture.createMultiSelectConfig();
        config.value = "I should break";
        new MultiSelectAutocompleteMock(config);
      }).toThrow(
        new AutocompleteProviderError(`options.value. Value "I should break" should be an Array of IDs`),
      );
    });

  });

  describe("Initialize Options", () => {
    let multiselect: MultiSelectAutocompleteMock;
    let config: AutocompleteConfiguration;
    beforeEach(() => {
      multiselect = undefined;
      config = AutocompleteOptionsFixture.createMultiSelectConfig();
    });

    it("sets initialValue to array value from supplied value object", () => {
      let expectedValue = [1, 5, 8];
      config.value = expectedValue;

      multiselect = new MultiSelectAutocompleteMock(config);

      expect(multiselect.getInitialValue()).toEqual(expectedValue);
    });

    it("setValue does not modify value and sets array of ids correctly", () => {
      const expectedValue = [1, 2];
      multiselect = new MultiSelectAutocompleteMock(config);

      multiselect.setValue(expectedValue);

      expect(multiselect.getKendoComponent().value()).toEqual(expectedValue);
    });

    describe("minLength", () => {

      it("sets minLength to 1 if not supplied in the config.options", () => {
        let expectedMinLength = 1;
        config.options.minLength = undefined;

        multiselect = new MultiSelectAutocompleteMock(config);

        expect(multiselect.getInternalConfig().options.minLength).toEqual(expectedMinLength);
      });

      it("sets minLength to overridden value if supplied in the config.options", () => {
        let expectedMinLength = 10;
        config.options.minLength = expectedMinLength;

        multiselect = new MultiSelectAutocompleteMock(config);

        expect(multiselect.getInternalConfig().options.minLength).toEqual(expectedMinLength);
      });
    });

    describe("autoBind", () => {

      it("sets autoBind to true by default", () => {
        delete config.options.autoBind;
        multiselect = new MultiSelectAutocompleteMock(config);

        expect(multiselect.getAutoBindValue()).toEqual(true);
      });

      it("sets autoBind to false if overridden by the config.options.autoBind", () => {
        config.options.autoBind = false;
        multiselect = new MultiSelectAutocompleteMock(config);

        expect(multiselect.getAutoBindValue()).toEqual(false);
      });
    });

  });
});
