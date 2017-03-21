import * as $ from "jquery";
import { AbstractAutocompleteMock } from "./mocks/autocomplete.abstract.mock";
import { AutocompleteOptions } from "../providers/autocomplete-options.interface";
import { AutocompleteOptionsTestFixture } from "./fixtures/autocomplete-opts-test-fixture";

describe("ThemisComponents: Abstract Factory: AbstractAutocomplete", () => {

  let opts = AutocompleteOptionsTestFixture.createAutocompleteOptions();
  let autocomplete = new AbstractAutocompleteMock(opts);

  describe("#toggleEnabled", () => {
    it("is expected to be enabled by default", () => {
      expect(autocomplete.isEnabled).toBe(true);
    });

    it("is disabled when toggled off", () => {
      autocomplete.toggleEnabled();
      expect(autocomplete.isEnabled).toBe(false);
    });
  });

  describe("#toggleSearchHint", () => {
    let list: any = autocomplete.getKendoComponent().list;

    it("expects the search hint not to exist by default", () => {
      expect($(list).find(".search-hint").length).toBe(0);
    });

    describe("when showHint is true", () => {
      it("adds the search hint element to the list element", () => {
        autocomplete.toggleSearchHint(true);
        expect($(list).find(".search-hint").length).toBe(1);
      });
    });

    describe("when showHint is false", () => {
      it("removes the search hint element from the list element", () => {
        autocomplete.toggleSearchHint(false);
        expect($(list).find(".search-hint").length).toBe(0);
      });
    });
  });

  describe("initializeOptions()", () => {
      let opts: AutocompleteOptions;
      beforeEach(() => {
        opts = AutocompleteOptionsTestFixture.createAutocompleteOptions();
      });

      it("sets enabled to false if ngDisabled present", () => {
        opts.ngDisabled = true;

        let mockAutocomplete = new AbstractAutocompleteMock(opts);

        expect(mockAutocomplete.isEnabled).toEqual(false);
      });

      describe("filterType", () => {
        it("sets filterType to a default value", () => {
          let mockAutocomplete = new AbstractAutocompleteMock(opts);

          expect(mockAutocomplete.getFilterType()).toEqual("startswith");
        });

        it("overrides filterType to value specified in options.delegate.filterType", () => {
          let expectedFilterType = "endswith";
          opts.delegate.filterType = expectedFilterType;

          let mockAutocomplete = new AbstractAutocompleteMock(opts);

          expect(mockAutocomplete.getFilterType()).toEqual(expectedFilterType);
        });
      });

      it("sets initialValue to displayField value if value is set as an object", () => {
        let expectedValue = {id: 1, name: "Stanley"};
        opts.value = expectedValue;

        let mockAutocomplete = new AbstractAutocompleteMock(opts);

        expect(mockAutocomplete.getInitialValue()).toEqual(expectedValue.name);

      });

      describe("autoBind", () => {
        it("sets autoBind to a default value", () => {
          let mockAutocomplete = new AbstractAutocompleteMock(opts);

          expect(mockAutocomplete.getAutoBind()).toEqual(false);
        });

        it("sets autoBind to true if delegate.autoBind present", () => {
          opts.delegate.autoBind = true;

          let mockAutocomplete = new AbstractAutocompleteMock(opts);

          expect(mockAutocomplete.getAutoBind()).toEqual(true);
        });

      });

      describe("setValue", () => {
        it("sets the kendo autocomplete value when called", () => {
          const expectedValue = {id: 1, name: "Stanley"};
          opts.value = expectedValue;

          const mockAutocomplete = new AbstractAutocompleteMock(opts);
          mockAutocomplete.create();
          expect(mockAutocomplete.getValue()).toEqual("");

          mockAutocomplete.setValue(expectedValue);
          expect(mockAutocomplete.getValue()).toEqual(expectedValue.name);
        });
      });

  });
});
