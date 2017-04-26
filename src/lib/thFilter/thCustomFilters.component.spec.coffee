describe "ThemisComponents: Component: thCustomFilters", ->
  filterSet = CustomFilterConverter = httpBackend = null
  thFilterCtrl = $componentController = null

  createFilterCtrl = (bindings) ->
    Object.assign bindings, registerInitPromise: jasmine.createSpy "registerInitPromise"

  createController = (bindings) ->
    controller = $componentController "thCustomFilters"
    controller.thFilterCtrl = createFilterCtrl bindings
    return controller

  beforeEach angular.mock.module "ThemisComponents"
  beforeEach ->
    inject (
      $injector
      FilterSet
      _CustomFilterConverter_
      $httpBackend
      _$componentController_
    ) ->
      CustomFilterConverter = _CustomFilterConverter_
      httpBackend = $httpBackend
      $componentController = _$componentController_
      filterSet = new FilterSet {onFilterChange: -> return}

  describe "when the component controller is instantiated", ->
    it "should register an init promise with the parent Filter controller", ->
      controller = createController
        options:
          filterSet: filterSet
          customFilterTypes: []

      expect(controller.thFilterCtrl.registerInitPromise.calls.count()).toEqual 0
      controller.$onInit()
      initPromiseCalls = controller.thFilterCtrl.registerInitPromise.calls
      expect(initPromiseCalls.count()).toEqual 1
      expect(initPromiseCalls.argsFor(0)[0] instanceof Promise).toEqual true

  describe "when filter set is undefined", ->
    it "should throw an error", ->
      controller = createController options: customFilterTypes: []
      expect(controller.$onInit).toThrow()

  describe "when list is undefined", ->
    it "should throw an error", ->
      controller = createController options: filterSet: filterSet
      expect(controller.$onInit).toThrow()

  describe "when filter set is defined on th-filter", ->
    it "should use the supplied filter set", ->
      controller = createController
        options:
          filterSet: filterSet
          customFilterTypes: []
      controller.$onInit()
      expect(controller.filterSet).toBe filterSet

  describe "when component is initialized", ->
    it "should have zero rows", ->
      controller = createController
        options:
          filterSet: filterSet
          customFilterTypes: []

      controller.$onInit()
      expect(controller.customFilterRows.length).toBe 0

  describe "when specifying custom filter url with no converter", ->
    controller = null
    endpoint = -> "/custom_filter.json"
    results = -> [
      {type: "input", fieldIdentifier: "id0", name: "input"}
      {type: "select", fieldIdentifier: "id1", name: "select"}
    ]

    beforeEach ->
      controller = createController
        options:
          filterSet: filterSet
          customFilterUrl: endpoint()
          initialState:
            id0: value: "test"
            idx: value: "unknown"

      controller.$onInit()

    it "should fetch custom filters from url", ->
      httpBackend.expectGET(endpoint()).respond JSON.stringify results()
      httpBackend.flush()

    it "should set customFilterTypes to response", ->
      response = results()
      httpBackend.whenGET(endpoint()).respond JSON.stringify response
      httpBackend.flush()

      expect(controller.customFilterTypes.length).toBe response.length
      expect(controller.customFilterTypes[0].type).toBe response[0].type
      expect(controller.customFilterTypes[0].fieldIdentifier).toBe response[0].fieldIdentifier
      expect(controller.customFilterTypes[0].name).toBe response[0].name
      expect(controller.customFilterTypes[1].type).toBe response[1].type
      expect(controller.customFilterTypes[1].fieldIdentifier).toBe response[1].fieldIdentifier
      expect(controller.customFilterTypes[1].name).toBe response[1].name

    it "should add a row for each initial known name/value pair", ->
      httpBackend.whenGET(endpoint()).respond JSON.stringify results()
      httpBackend.flush()

      expect(controller.customFilterRows.length).toBe 1
      expect(controller.customFilterRows[0].initialState).toEqual {value: "test"}

    it "should resolve the promise registered with thFilter", (done) ->
      promise = controller.thFilterCtrl.registerInitPromise.calls.argsFor(0)[0]
      promise.then -> done()

      httpBackend.whenGET(endpoint()).respond JSON.stringify results()
      httpBackend.flush()

    describe "and the amount of results is less than the given MAX_API_RESULTS", ->
      it "disables serverFiltering", ->
        dataSource = options: serverFiltering: true
        twoResults = results()
        controller._disableServerFilteringIfNoFurtherPagesOfResults twoResults, dataSource, 3
        expect(dataSource.options.serverFiltering).toBe false

    describe "and the amount of results is more than the given MAX_API_RESULTS", ->
      it "doesn't disable serverFiltering", ->
        dataSource = options: serverFiltering: true
        twoResults = results()
        controller._disableServerFilteringIfNoFurtherPagesOfResults twoResults, dataSource, 1
        expect(dataSource.options.serverFiltering).toBe true

  describe "when specifying custom filter url with converter", ->
    describe "when custom filter converter is not valid", ->
      it "should throw an error", ->
        controller = createController
          options:
            filterSet: filterSet
            customFilterUrl: "/custom_filter.json"
            customFilterConverter: null

        expect(controller.$onInit).toThrow()

    describe "when custom filter converter is valid", ->
      controller = null
      convertSpy = null
      idPrefix = -> "convertedId"
      namePrefix = -> "convertedName"
      typePrefix = -> "convertedType"
      endpoint = -> "/custom_filter.json"
      results = -> [
        {id: 0}
        {id: 1}
      ]

      beforeEach ->
        class TestCustomFilterConverter extends CustomFilterConverter
          mapToCustomFilterArray: (data) ->
            convertedResults = data.map (item) ->
              fieldIdentifier: idPrefix() + item.id
              name: namePrefix() + item.id
              type: typePrefix() + item.id
            return [convertedResults, showSearchHint: true]
        testConverter = new TestCustomFilterConverter()
        convertSpy = spyOn(testConverter, "mapToCustomFilterArray").and.callThrough()

        controller = createController
          options:
            filterSet: filterSet
            customFilterUrl: endpoint()
            customFilterConverter: testConverter

        controller.$onInit()

      it "should fetch custom filters from url", ->
        httpBackend.expectGET(endpoint()).respond JSON.stringify results()
        httpBackend.flush()

      it "should call 'mapToCustomFilterArray'", ->
        httpBackend.whenGET(endpoint()).respond JSON.stringify results()
        httpBackend.flush()
        expect(convertSpy).toHaveBeenCalledTimes(1)

      it "should set 'customFilterTypes' to converted response", ->
        response = results()
        httpBackend.whenGET(endpoint()).respond JSON.stringify response
        httpBackend.flush()

        expect(controller.customFilterTypes.length).toBe response.length
        expect(controller.customFilterTypes[0].type).toBe typePrefix() + response[0].id
        expect(controller.customFilterTypes[0].fieldIdentifier).toBe idPrefix() + response[0].id
        expect(controller.customFilterTypes[0].name).toBe namePrefix() + response[0].id
        expect(controller.customFilterTypes[1].type).toBe typePrefix() + response[1].id
        expect(controller.customFilterTypes[1].fieldIdentifier).toBe idPrefix() + response[1].id
        expect(controller.customFilterTypes[1].name).toBe namePrefix() + response[1].id

      it "should resolve the promise registered with thFilter", (done) ->
        promise = controller.thFilterCtrl.registerInitPromise.calls.argsFor(0)[0]
        promise.then -> done()

        httpBackend.whenGET(endpoint()).respond JSON.stringify results()
        httpBackend.flush()

  describe "when specifying an invalid custom filter url", ->
    controller = null
    endpoint = -> "soo bogus"

    beforeEach ->
      controller = createController
        options:
          filterSet: filterSet
          customFilterUrl: endpoint()

      controller.$onInit()

    it "should reject the promise registered with thFilter", (done) ->
      promise = controller.thFilterCtrl.registerInitPromise.calls.argsFor(0)[0]
      promise
        .catch -> done()

      httpBackend.whenGET(endpoint()).respond 404
      httpBackend.flush()

  describe "#addCustomRow", ->
    it "should add one row", ->
      controller = createController
        options:
          filterSet: filterSet
          customFilterTypes: []

      controller.$onInit()
      controller.addCustomFilterRow()
      expect(controller.customFilterRows.length).toEqual 1
      controller.addCustomFilterRow()
      expect(controller.customFilterRows.length).toEqual 2

  describe "#removeCustomRow", ->
    firstIndex = lastIndex = controller = null

    beforeEach ->
      controller = createController
        options:
          filterSet: filterSet
          customFilterTypes: []

      controller.$onInit()
      controller.addCustomFilterRow()
      controller.addCustomFilterRow()

    describe "when called with invalid index", ->
      it "should throw an error", ->
        expect(-> controller.removeCustomFilterRow lastIndex + 1).toThrow()

    describe "when called with index of first element repeatedly", ->
      it "should remove the first element from its customFilterRows array repeatedly", ->
        rows = controller.customFilterRows
        expect(rows.length).toBe 2
        controller.removeCustomFilterRow rows[0].identifier
        expect(rows.length).toBe 1
        controller.removeCustomFilterRow rows[0].identifier
        expect(rows.length).toBe 0

    describe "when called with index of last element", ->
      it "should remove last element from its customFilterRows array", ->
        rows = controller.customFilterRows
        controller.removeCustomFilterRow rows[rows.length - 1].identifier
        expect(rows.length).toBe 1
