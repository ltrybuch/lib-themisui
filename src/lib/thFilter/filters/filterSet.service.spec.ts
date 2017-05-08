import * as angular from "angular";
import "angular-mocks";
import FilterSet from "./filterSet.service";
import { FilterBase, FilterBaseFactory, FilterSetFactory } from "../thFilter.interface";

describe("ThemisComponents: Service: FilterSet", () => {
  let SelectFilter: FilterBaseFactory;
  let selectFilter1: FilterBase;
  let selectFilter2: FilterBase;
  let FilterSet: FilterSetFactory;
  let filterSet: FilterSet;

  beforeEach(angular.mock.module("ThemisComponents"));

  beforeEach(inject((_FilterSet_: FilterSetFactory, _SelectFilter_: FilterBaseFactory) => {
    FilterSet = _FilterSet_;
    SelectFilter = _SelectFilter_;
    filterSet = null;
    selectFilter1 = null;
    selectFilter2 = null;
  }));

  describe("#constructor: ", () => {
    describe("When 'onFilterChange' is not specified: ", () => {
      it("should throw an error", () => {
        expect(() => new FilterSet({} as any)).toThrow();
      });
    });

    describe("When 'onFilterChange' is specified: ", () => {
      it("shouldn't throw an error", () => {
        expect(() => new FilterSet({
          onFilterChange: () => null,
        })).not.toThrow();
      });
    });

    describe("when 'onInitialized' is specified: ", () => {
      it("should return a new FilterSet object", (done) => {
        const onFilterChange = jasmine.createSpy("onFilterChange");
        const onInitialized = () => ({});

        filterSet = new FilterSet({ onFilterChange, onInitialized });
        filterSet.onFilterChange();
        filterSet.onFilterChange();
        filterSet.onFilterChange();

        // filterSet.onFilterChange() debounces with a timeout of 300ms
        setTimeout(() => {
          expect(filterSet instanceof FilterSet).toBe(true);
          expect(onFilterChange).toHaveBeenCalledTimes(1);
          expect(filterSet.onInitialized).toBe(onInitialized);
          done();
        }, 300);
      });
    });
  });

  describe("#remove: ", () => {
    beforeEach(() => {
      filterSet = new FilterSet({
        onFilterChange: () => undefined,
      });
      selectFilter1 = new SelectFilter({} as any);
      selectFilter2 = new SelectFilter({} as any);
    });

    describe("When element does not exist: ", () => {
      it("should stay the same", () => {
        filterSet.push(selectFilter1, selectFilter2);

        expect(filterSet.length).toBe(2);
        expect(() => filterSet.remove(undefined)).toThrow();
        expect(filterSet.length).toBe(2);
        expect(filterSet.get(0)).toBe(selectFilter1);
        expect(filterSet.get(1)).toBe(selectFilter2);
      });
    });

    describe("When element exists: ", () => {
      it("should remove element", () => {
        filterSet.push(selectFilter1, selectFilter2);
        expect(filterSet.length).toBe(2);

        filterSet.remove(selectFilter2);
        expect(filterSet.length).toBe(1);
        expect(filterSet.get(0)).toBe(selectFilter1);
      });
    });
  });

  describe("#getState: ", () => {
    beforeEach(() => {
      filterSet = new FilterSet({
        onFilterChange: () => undefined,
      });
    });

    describe("When the filterSet is empty: ", () => {
      it("should return the empty set", () => {
        expect(Object.keys(filterSet.getState()).length).toBe(0);
      });
    });

    describe("When the filterSet is not empty: ", () => {
      beforeEach(() => {
        selectFilter1 = new SelectFilter({ fieldIdentifier: "name1", name: "name1" });
        selectFilter2 = new SelectFilter({ fieldIdentifier: "name2", name: "name2" });
      });

      describe("When the filetSet has one filter: ", () => {
        describe("When the filter value is undefined: ", () => {
          it("should return the empty set", () => {
            filterSet.push(selectFilter1);
            expect(Object.keys(filterSet.getState()).length).toBe(0);
          });
        });

        describe("When the filter value is defined: ", () => {
          it("should return the query string", () => {
            const model = { name: "name1", value: "value1" };
            (selectFilter1 as any).model = model;
            filterSet.push(selectFilter1);

            const params = filterSet.getState();
            expect(Object.keys(params).length).toBe(1);
            expect(params.name1).toEqual(model);
          });
        });
      });

      describe("When the filterSet has more than one filter: ", () => {
        it("should return the query string", () => {
          const model1 = { name: "name1", value: "value1" };
          const model2 = { name: "name2", value: "value2" };
          (selectFilter1 as any).model = model1;
          (selectFilter2 as any).model = model2;
          filterSet.push(selectFilter1);
          filterSet.push(selectFilter2);

          const params = filterSet.getState();
          expect(Object.keys(params).length).toBe(2);
          expect(params.name1).toEqual(model1);
          expect(params.name2).toEqual(model2);
        });
      });
    });
  });

  describe("#getMetaData: ", () => {
    beforeEach(() => {
      filterSet = new FilterSet({
        onFilterChange: () => undefined,
      });
    });

    describe("when filter set is empty: ", () => {
      it("should return the empty set", () => {
        expect(Object.keys(filterSet.getMetadata()).length).toBe(0);
      });
    });

    describe("when filter set is not empty: ", () => {
      let expectedMetadata: any;

      beforeEach(() => {
        expectedMetadata = { someData: "test" };
        selectFilter1 = new SelectFilter({ fieldIdentifier: "name1", name: "name1" });
        selectFilter2 = new SelectFilter({ fieldIdentifier: "name2", name: "name2", metadata: expectedMetadata });
      });

      describe("when filter set has one filter: ", () => {
        describe("when metadata is undefined: ", () => {
          it("should return the empty set", () => {
            filterSet.push(selectFilter1);
            expect(Object.keys(filterSet.getMetadata()).length).toBe(0);
          });
        });

        describe("when metadata is defined: ", () => {
          it("should return the metadata", () => {
            filterSet.push(selectFilter2);
            const metadata = filterSet.getMetadata();
            expect(Object.keys(metadata).length).toBe(1);
            expect(metadata.name2).toBe(expectedMetadata);
          });
        });
      });
    });
  });

  describe("#getDataSourceState: ", () => {
    beforeEach(() => {
      filterSet = new FilterSet({
        onFilterChange: () => undefined,
      });
    });

    describe("When the filterSet is empty: ", () => {
      it("should return an empty array", () => {
        expect(filterSet.getDataSourceState()).toEqual([]);
      });
    });

    describe("When the filterSet is not empty: ", () => {
      beforeEach(() => {
        selectFilter1 = new SelectFilter({ fieldIdentifier: "name1", name: "name1" });
        selectFilter2 = new SelectFilter({ fieldIdentifier: "name2", name: "name2" });
      });

      describe("When the filetSet has one filter: ", () => {
        describe("When the filter value is undefined: ", () => {
          it("should return an empty array", () => {
            filterSet.push(selectFilter1);
            expect(filterSet.getDataSourceState()).toEqual([]);
          });
        });

        describe("When the filter value is defined: ", () => {
          it("should return an array holding the filter object", () => {
            const model = { name: "name1", value: "value1" };
            (selectFilter1 as any).model = model;
            filterSet.push(selectFilter1);

            const dataSourceState = filterSet.getDataSourceState();
            expect(dataSourceState.length).toBe(1);
            expect(dataSourceState[0]).toEqual({ field: model.name, value: model.value, operator: "eq" });
          });
        });
      });

      describe("When the filterSet has more than one filter: ", () => {
        it("should return an array holding the filter objects", () => {
          const model1 = { name: "name1", value: "value1" };
          const model2 = { name: "name2", value: "value2" };
          (selectFilter1 as any).model = model1;
          (selectFilter2 as any).model = model2;
          filterSet.push(selectFilter1);
          filterSet.push(selectFilter2);

          const dataSourceState = filterSet.getDataSourceState();
          expect(dataSourceState.length).toBe(2);
          expect(dataSourceState[0]).toEqual({ field: model1.name, value: model1.value, operator: "eq" });
          expect(dataSourceState[1]).toEqual({ field: model2.name, value: model2.value, operator: "eq" });
        });
      });
    });
  });
});
