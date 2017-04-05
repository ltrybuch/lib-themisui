import * as $ from "jquery";
import AutocompleteAbstractMock from "../mocks/autocomplete.abstract.mock";
import { AutocompleteConfiguration } from "../../providers/autocomplete.interface";
import AutocompleteOptionsFixture from "../fixtures/autocomplete-opts.fixture";
import { AutocompleteProviderError } from "../../autocomplete.errors";

describe("ThemisComponents: thAutocomplete : AutocompleteAbstract", () => {

  let config = AutocompleteOptionsFixture.createAutocompleteConfig();
  let autocomplete = new AutocompleteAbstractMock(config);

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

  describe("Validations", () => {
    let config: AutocompleteConfiguration;

    beforeEach(() => {
      config = AutocompleteOptionsFixture.createAutocompleteConfig();
    });

    it("should throw an error when options object is missing ", () => {
      expect(function() {
        config.options = null;
        new AutocompleteAbstractMock(config);
      }).toThrow(new AutocompleteProviderError(`You must provide the "options" parameter.`));
    });

    it("should throw an error when options.displayField is missing ", () => {
      expect(function() {
        config.options.displayField = "";
        new AutocompleteAbstractMock(config);
      }).toThrow(new AutocompleteProviderError("options.displayField is required"));
    });

  });

  describe("initializeOptions()", () => {
    let config: AutocompleteConfiguration;
    beforeEach(() => {
      config = AutocompleteOptionsFixture.createAutocompleteConfig();
    });

    it("sets enabled to false if ngDisabled present", () => {
      config.ngDisabled = true;

      let autocomplete = new AutocompleteAbstractMock(config);

      expect(autocomplete.isEnabled).toEqual(false);
    });

    describe("filter", () => {
      it("sets filter to a default value", () => {
        const autocomplete = new AutocompleteAbstractMock(config);

        expect(autocomplete.getFilter()).toEqual("startswith");
      });

      it("overrides filter to value specified in options.filter", () => {
        let expectedFilter = "endswith";
        config.options.filter = expectedFilter;

        let autocomplete = new AutocompleteAbstractMock(config);

        expect(autocomplete.getFilter()).toEqual(expectedFilter);
      });
    });

    describe("autoBind", () => {
      it("sets autoBind to a default value of true", () => {
        const autocomplete = new AutocompleteAbstractMock(config);

        expect(autocomplete.getAutoBind()).toEqual(true);
      });

      it("sets autoBind to false if config.options.autoBind overrides the default", () => {
        config.options.autoBind = false;

        const autocomplete = new AutocompleteAbstractMock(config);

        expect(autocomplete.getAutoBind()).toEqual(false);
      });

    });

    describe("setValue", () => {
      it("sets the kendo autocomplete value when called", () => {
        const expectedValue = {id: 1, name: "Stanley"};
        config.value = expectedValue;

        const autocomplete = new AutocompleteAbstractMock(config);
        autocomplete.create();
        expect(autocomplete.getValue()).toEqual("");

        autocomplete.setValue(expectedValue);
        expect(autocomplete.getValue()).toEqual(expectedValue.name);
      });
    });

  });
});
