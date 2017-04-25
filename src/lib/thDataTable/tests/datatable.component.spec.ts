import * as angular from "angular";
import "angular-mocks";
import { staticColumns, fakeDataObj as expectedDataObj } from "./fixtures/tabledata";
import { DataTable } from "../data-table.component";
import { DataTableService } from "../data-table.service";
import DataSource from "../../services/data-source.service";
const SpecHelpers: any = require("spec_helpers");

const componentName = "thDataTable";
const staticData = expectedDataObj.items;
let dataTableComponentCtrl: DataTable;
let dataTableService: DataTableService;
let dataTableServiceCreateSpy: jasmine.Spy;
let $componentController: angular.IComponentControllerService;
let element: JQuery;
let scope: any;

describe("ThemisComponents: Component: DataTable", () => {
  beforeEach(angular.mock.module("ThemisComponents"));

  beforeEach(inject((
    DataSource: DataSource,
    _DataTableService_: DataTableService,
    _$componentController_: angular.IComponentControllerService,
  ) => {
    dataTableService = _DataTableService_;
    $componentController = _$componentController_;
    dataTableComponentCtrl = null;
    scope = {
      opts: {
        columns: staticColumns,
        dataSource: DataSource.createDataSource({ data: staticData }),
      },
    };

    spyOn(dataTableService, "create");
    dataTableServiceCreateSpy = dataTableService.create as jasmine.Spy;
  }));

  afterEach(() => {
    if (element) {
      element.remove();
    }
  });

  describe("when options is specified: ", () => {
    it("creates a data table", () => {
      const dataTable = `<th-data-table options="opts"></th-data-table>`;
      dataTableServiceCreateSpy.and.callThrough();

      element = SpecHelpers.compileDirective(dataTable, scope).element;
      expect(element.find(".k-grid-content table").length).toEqual(1);
    });
  });

  describe("#$onInit: ", () => {
    const locals = { $element: angular.element("<div>") };

    describe("With options.selectable specified: ", () => {
      beforeEach(() => {
        const options = { ...scope.opts, selectable: true };
        dataTableComponentCtrl = $componentController(componentName, locals, { options }) as DataTable;
        dataTableComponentCtrl.$onInit();
      });

      it("calls the DataTableService.create with the columns and databound properties", () => {
        expect(dataTableServiceCreateSpy.calls.count()).toBe(1);

        const createOptions = dataTableServiceCreateSpy.calls.argsFor(0)[1];
        expect(createOptions.columns.length).toBe(scope.opts.columns.length + 1);
        expect(typeof createOptions.onDataBound).toBe("function");
      });
    });

    describe("Without options.selectable specified: ", () => {
      beforeEach(() => {
        const options = scope.opts;
        dataTableComponentCtrl = $componentController(componentName, locals, { options }) as DataTable;
        dataTableComponentCtrl.$onInit();
      });

      it("calls the DataTableService.create with the columns and databound properties", () => {
        expect(dataTableServiceCreateSpy.calls.count()).toBe(1);

        const createOptions = dataTableServiceCreateSpy.calls.argsFor(0)[1];
        expect(createOptions.columns.length).toBe(scope.opts.columns.length);
        expect(createOptions.onDataBound).toBeUndefined();
      });
    });

    describe("With options.resizable specified: ", () => {
      beforeEach(() => {
        const options = { ...scope.opts, resizable: true };
        dataTableComponentCtrl = $componentController(componentName, locals, { options }) as DataTable;
        dataTableComponentCtrl.$onInit();
      });

      it("calls the DataTableService.create with the resizable option", () => {
        const createOptions = dataTableServiceCreateSpy.calls.argsFor(0)[1];
        expect(dataTableServiceCreateSpy.calls.count()).toBe(1);
        expect(createOptions.resizable).toBe(true);
      });
    });

    describe("Without options.resizable specified: ", () => {
      beforeEach(() => {
        const options = scope.opts;
        dataTableComponentCtrl = $componentController(componentName, locals, { options }) as DataTable;
        dataTableComponentCtrl.$onInit();
      });

      it("calls the DataTableService.create without the resizable option", () => {
        const createOptions = dataTableServiceCreateSpy.calls.argsFor(0)[1];
        expect(dataTableServiceCreateSpy.calls.count()).toBe(1);
        expect(createOptions.hasOwnProperty("resizable")).toBe(false);
      });
    });
  });

  describe("#getSelectedSize: ", () => {
    beforeEach(() => {
      const locals = { $element: angular.element("<div>") };
      const options = { ...scope.opts, selectable: true };
      dataTableComponentCtrl = $componentController(componentName, locals, { options }) as DataTable;
    });

    it("returns 0 when no items are selected", () => {
      dataTableComponentCtrl.selectedRows = [];
      expect(dataTableComponentCtrl.getSelectedSize()).toBe(0);

      dataTableComponentCtrl.selectedRows = [false];
      expect(dataTableComponentCtrl.getSelectedSize()).toBe(0);
    });

    it("returns length when items are selected", () => {
      dataTableComponentCtrl.selectedRows = [false, true];
      expect(dataTableComponentCtrl.getSelectedSize()).toBe(1);
    });
  });

  describe("#updateHeaderCheckboxState: ", () => {
    const visibleRows = [0, 1, 2, 3, 4, 5];
    let onSelectionChange: jasmine.Spy;
    let setVisibleRowCallback: (rows: number[]) => void = null;

    beforeEach(() => {
      onSelectionChange = jasmine.createSpy("onSelectChange");
      const locals = { $element: angular.element("<div>") };
      const options = { ...scope.opts, selectable: true, onSelectionChange };

      dataTableComponentCtrl = $componentController(componentName, locals, { options }) as DataTable;
      dataTableComponentCtrl.$onInit();
      setVisibleRowCallback = dataTableServiceCreateSpy.calls.argsFor(0)[1].onDataBound;
      setVisibleRowCallback(visibleRows);
    });

    it("sets the correct properties when no rows are selected", () => {
      dataTableComponentCtrl.selectedRows = [];
      dataTableComponentCtrl.updateHeaderCheckboxState();

      expect(dataTableComponentCtrl.partialPageSelected).toBe(false);
      expect(dataTableComponentCtrl.wholePageSelected).toBe(false);
    });

    it("sets the correct properties when some rows are selected", () => {
      dataTableComponentCtrl.selectedRows = [true, true];
      dataTableComponentCtrl.updateHeaderCheckboxState();

      expect(dataTableComponentCtrl.partialPageSelected).toBe(true);
      expect(dataTableComponentCtrl.wholePageSelected).toBe(false);
    });

    it("sets the correct properties when all rows are selected", () => {
      dataTableComponentCtrl.selectedRows = [true, true, true, true, true, true];
      dataTableComponentCtrl.updateHeaderCheckboxState();

      expect(dataTableComponentCtrl.partialPageSelected).toBe(false);
      expect(dataTableComponentCtrl.wholePageSelected).toBe(true);
    });

    it("calls the onSelectionChange callback", () => {
      dataTableComponentCtrl.updateHeaderCheckboxState();
      expect(onSelectionChange).toHaveBeenCalled();
    });
  });

  describe("#togglePage: ", () => {
    const visibleRows = [0, 1, 2, 3, 4, 5];
    const allSelected = [true, true, true, true, true, true];
    const noneSelected = [false, false, false, false, false, false];
    let setVisibleRowCallback: (rows: number[]) => void = null;

    beforeEach(() => {
      const locals = { $element: angular.element("<div>") };
      const options = { ...scope.opts, selectable: true };

      dataTableComponentCtrl = $componentController(componentName, locals, { options }) as DataTable;
      dataTableComponentCtrl.$onInit();
      setVisibleRowCallback = dataTableServiceCreateSpy.calls.argsFor(0)[1].onDataBound;
      setVisibleRowCallback(visibleRows);
      spyOn(dataTableComponentCtrl, "updateHeaderCheckboxState");
    });

    it("sets all visible rows as selected when no rows are selected", () => {
      dataTableComponentCtrl.selectedRows = [];
      dataTableComponentCtrl.togglePage();
      expect(dataTableComponentCtrl.selectedRows).toEqual(allSelected);
    });

    it("sets all visible rows as selected when partial rows are selected", () => {
      dataTableComponentCtrl.selectedRows = [false, true, true];
      dataTableComponentCtrl.togglePage();
      expect(dataTableComponentCtrl.selectedRows).toEqual(allSelected);
    });

    it("sets all visible rows as unselected when all rows are selected", () => {
      dataTableComponentCtrl.selectedRows = allSelected;
      dataTableComponentCtrl.togglePage();
      expect(dataTableComponentCtrl.selectedRows).toEqual(noneSelected);
    });

    it("calls updateHeaderCheckboxState", () => {
      dataTableComponentCtrl.togglePage();
      expect(dataTableComponentCtrl.updateHeaderCheckboxState as jasmine.Spy).toHaveBeenCalled();
    });
  });

  describe("#clearSelection: ", () => {
    beforeEach(() => {
      const locals = { $element: angular.element("<div>") };
      const options = { ...scope.opts, selectable: true };

      dataTableComponentCtrl = $componentController(componentName, locals, { options }) as DataTable;
      spyOn(dataTableComponentCtrl, "updateHeaderCheckboxState");
    });

    it("clears the selected rows collection", () => {
      dataTableComponentCtrl.selectedRows = [true, true, true];
      dataTableComponentCtrl.clearSelection();
      expect(dataTableComponentCtrl.selectedRows).toEqual([]);
    });

    it("calls updateHeaderCheckboxState", () => {
      dataTableComponentCtrl.clearSelection();
      expect(dataTableComponentCtrl.updateHeaderCheckboxState as jasmine.Spy).toHaveBeenCalled();
    });
  });
});
