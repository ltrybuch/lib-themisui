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

    describe "event broadcasting", ->
      describe "when there is no filter options selected", ->
        beforeEach -> controller.rowFilterOptions = []

        it "does not broadcast `thFilter:destroyed`", ->
          controller.onRowSelectChange()
          timeout.flush()
          expect(scope.$broadcast).not.toHaveBeenCalled()

      describe "when there is no filter options selected", ->
        beforeEach -> controller.rowFilterOptions = [{another: "filter"}]

        it "broadcasts `thFilter:destroyed`", ->
          controller.onRowSelectChange ""
          timeout.flush()
          expect(scope.$broadcast).toHaveBeenCalledWith "thFilter:destroyed"
