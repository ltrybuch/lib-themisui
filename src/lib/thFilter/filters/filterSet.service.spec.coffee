describe "ThemisComponents: Service: FilterSet", ->
  SelectFilter = selectFilter1 = selectFilter2 = FilterSet = filterSet = null

  beforeEach angular.mock.module "ThemisComponents"
  beforeEach inject ($injector, _FilterSet_, _SelectFilter_) ->
    FilterSet = _FilterSet_
    SelectFilter = _SelectFilter_

  describe "#constructor", ->
    describe "when 'onFilterChange' is not specified", ->
      it "should throw an error", ->
        expect(-> new FilterSet).toThrow()

    describe "when 'onFilterChange' is specified", ->
      describe "when 'onInitialized' is not specified", ->
        it "shouldn't throw an error", ->
          expect(-> new FilterSet(onFilterChange: -> return)).not.toThrow()

      describe "when 'onInitialized' is specified", ->
        it "should return a new FilterSet object", (done) ->
          test = -> return
          ofcSpy = jasmine.createSpy "onFilterChange"

          filterSet = new FilterSet {
            onFilterChange: ofcSpy
            onInitialized: test
          }
          filterSet.onFilterChange() for [1..3]

          setTimeout ->
            expect(filterSet).toBe instanceof Array
            expect(ofcSpy).toHaveBeenCalledTimes(1)
            expect(filterSet.onInitialized).toBe test
            done()
          , 400 #filterSet.onFilterChange() debounces with a timeout of 300ms

  describe "#remove", ->
    beforeEach ->
      filterSet = new FilterSet {
        onFilterChange: -> return
      }
      filterSet.push 0
      filterSet.push 1

    describe "when element does not exist", ->
      it "should stay the same", ->
        expect(filterSet.length).toBe 2
        filterSet.remove 2
        expect(filterSet.length).toBe 2
        expect(filterSet.toString()).toBe "0,1"

    describe "when element exists", ->
      it "should remove element", ->
        expect(filterSet.length).toBe 2
        filterSet.remove 0
        expect(filterSet.length).toBe 1
        expect(filterSet.toString()).toBe "1"

  describe "#getState", ->
    beforeEach ->
      filterSet = new FilterSet {
        onFilterChange: -> return
      }

    describe "when filter set is empty", ->
      it "should return the empty set", ->
        expect(Object.keys(filterSet.getState()).length).toBe 0

    describe "when filter set is not empty", ->
      beforeEach ->
        selectFilter1 = new SelectFilter {
          fieldIdentifier: "name1"
        }
        selectFilter2 = new SelectFilter {
          fieldIdentifier: "name2"
        }

      describe "when filter set has one filter", ->
        beforeEach ->
          filterSet.push selectFilter1

        describe "when filter value is undefined", ->
          it "should return the empty string", ->
            expect(Object.keys(filterSet.getState()).length).toBe 0

        describe "when filter value is defined", ->
          beforeEach ->
            selectFilter1.model = {name: "name1", value: "value1"}

          it "should return the query string", ->
            params = filterSet.getState()
            expect(Object.keys(params).length).toBe 1
            expect(params.name1).toEqual {name: "name1", value: "value1"}

      describe "when filter set has more than one filter", ->
        beforeEach ->
          selectFilter1.model = {name: "name1", value: "value1"}
          selectFilter2.model = {name: "name2", value: "value2"}
          filterSet.push selectFilter1
          filterSet.push selectFilter2

        it "should return the query string", ->
          params = filterSet.getState()
          expect(Object.keys(params).length).toBe 2
          expect(params.name1).toEqual {name: "name1", value: "value1"}
          expect(params.name2).toEqual {name: "name2", value: "value2"}

  describe "#getMetadata", ->
    beforeEach ->
      filterSet = new FilterSet {
        onFilterChange: -> return
      }

    describe "when filter set is empty", ->
      it "should return the empty set", ->
        expect(Object.keys(filterSet.getMetadata()).length).toBe 0

    describe "when filter set is not empty", ->
      beforeEach ->
        @metadata = {someData: "test"}
        selectFilter1 = new SelectFilter {
          fieldIdentifier: "name1"
        }
        selectFilter2 = new SelectFilter {
          fieldIdentifier: "name2"
          @metadata
        }

      describe "when filter set has one filter", ->
        beforeEach ->
          filterSet.push selectFilter1

        describe "when metadata is undefined", ->
          it "should return the empty set", ->
            expect(Object.keys(filterSet.getMetadata()).length).toBe 0

        afterEach ->
          filterSet.remove selectFilter1

        describe "when metadata is defined", ->
          beforeEach ->
            filterSet.push selectFilter2

          it "should return the metadata", ->
            metadata = filterSet.getMetadata()
            expect(Object.keys(metadata).length).toBe 1
            expect(metadata.name2).toBe @metadata

          afterEach ->
            filterSet.remove selectFilter2
