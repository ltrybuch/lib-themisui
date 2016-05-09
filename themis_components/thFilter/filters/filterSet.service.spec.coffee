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
      it "should return a new FilterSet object", ->
        test = -> return
        filterSet = new FilterSet {
          onFilterChange: test
        }
        expect(filterSet).toBe instanceof Array
        expect(filterSet.onFilterChange).toBe test

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

  describe "#getQueryParameters", ->
    beforeEach ->
      filterSet = new FilterSet {
        onFilterChange: -> return
      }

    describe "when filter set is empty", ->
      it "should return the empty set", ->
        expect(Object.keys(filterSet.getQueryParameters()).length).toBe 0

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
            expect(Object.keys(filterSet.getQueryParameters()).length).toBe 0

        describe "when filter value is defined", ->
          beforeEach ->
            selectFilter1.model = {value: "value1"}

          it "should return the query string", ->
            params = filterSet.getQueryParameters()
            expect(Object.keys(params).length).toBe 1
            expect(params.name1).toBe "value1"

      describe "when filter set has more than one filter", ->
        beforeEach ->
          selectFilter1.model = {value: "value1"}
          selectFilter2.model = {value: "value2"}
          filterSet.push selectFilter1
          filterSet.push selectFilter2

        it "should return the query string", ->
          params = filterSet.getQueryParameters()
          expect(Object.keys(params).length).toBe 2
          expect(params.name1).toBe "value1"
          expect(params.name2).toBe "value2"

  describe "#getQueryString", ->
    beforeEach ->
      filterSet = new FilterSet {
        onFilterChange: -> return
      }

    describe "when filter set is empty", ->
      it "should return the empty string", ->
        expect(filterSet.getQueryString()).toBe ""

    describe "when filter set is not empty", ->
      beforeEach ->
        selectFilter1 = new SelectFilter {
          fieldIdentifier: "name"
        }

      describe "when filter set has one filter", ->
        beforeEach ->
          filterSet.push selectFilter1

        describe "when filter value is undefined", ->
          it "should return the empty string", ->
            expect(filterSet.getQueryString()).toBe ""

        describe "when filter value is defined", ->
          beforeEach ->
            selectFilter1.model = {value: "value"}

          it "should return the query string", ->
            expect(filterSet.getQueryString()).toBe "name=value"

      describe "when filter set has more than one filter", ->
        beforeEach ->
          selectFilter1.model = {value: "value"}
          filterSet.push selectFilter1
          filterSet.push selectFilter1

        it "should return the query string", ->
          expect(filterSet.getQueryString()).toBe "name=value&name=value"
