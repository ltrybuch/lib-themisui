describe "ThemisComponents: Controller: thCustomFilterRow", ->
  controller = timeout = null
  scope = { $broadcast: jasmine.createSpy("$broadcast") }

  filterType = {
    name: 'name'
    type: 'select'
    fieldIdentifier: 'id'
    placeholder: 'placeholder'
    data: [
      {name: '1', value: '1'}
      {name: '2', value: '2'}
    ]
  }

  beforeEach angular.mock.module "ThemisComponents"
  beforeEach angular.mock.inject ($controller, $timeout) ->
    timeout = $timeout
    controller = $controller("thCustomFilterRow.controller", $timeout: timeout, $scope: scope)

  describe "#onRowSelectChanged", ->
    describe "when selected value is null or undefined", ->
      beforeEach -> controller.rowSelectValue = undefined

      it "sets to empty array", ->
        controller.onRowSelectChange()
        timeout.flush()
        expect(controller.rowFilterOptions.length).toBe 0

    describe "when selected value is filter", ->
      beforeEach -> controller.rowSelectValue = filterType

      it "adds filter to array as only element", ->
        controller.onRowSelectChange()
        timeout.flush()
        expect(controller.rowFilterOptions).toEqual [filterType]

    describe "when a custom field has been added", ->
      beforeEach ->
        controller.customFieldOptions = {trackField: "fieldIdentifier"}

      describe "with an undefined value", ->
        beforeEach -> controller.rowFilterOptions = []

        it "does not broadcast `thFilter:destroyed`", ->
          controller.onRowSelectChange undefined
          timeout.flush()
          expect(scope.$broadcast).not.toHaveBeenCalled()

      describe "and a filter type has just been selected", ->
        beforeEach -> controller.rowFilterOptions = []

        it "does not broadcast `thFilter:destroyed`", ->
          controller.onRowSelectChange()
          timeout.flush()
          expect(scope.$broadcast).not.toHaveBeenCalled()

      describe "and a filter type option value has just been selected", ->
        beforeEach -> controller.rowFilterOptions = [{fieldIdentifier: "status"}]

        it "does not broadcast `thFilter:destroyed`", ->
          # Emulate a value being updated on an existing filter type
          controller.onRowSelectChange {fieldIdentifier: "status"}
          timeout.flush()
          expect(scope.$broadcast).not.toHaveBeenCalled()

      describe "and the filter type has now been changed", ->
        beforeEach -> controller.rowFilterOptions = [{fieldIdentifier: "status"}]

        it "broadcasts `thFilter:destroyed`", ->
          controller.onRowSelectChange {fieldIdentifier: "difficulty"}
          timeout.flush()
          expect(scope.$broadcast).toHaveBeenCalledWith "thFilter:destroyed"
