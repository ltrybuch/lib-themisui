import * as angular from "angular";
import "angular-mocks";
import { staticColumns, staticData } from "../fixtures/tabledata";
import { DataGrid } from "../data-grid.component";
import { DataGridService } from "../data-grid.service";
import DataSource from "../../services/data-source.service";
const SpecHelpers: any = require("spec_helpers");

const componentName = "thDataGrid";
let dataGridComponentCtrl: DataGrid;
let dataGridService: DataGridService;
let dataGridServiceCreateSpy: jasmine.Spy;
let $componentController: angular.IComponentControllerService;
let element: JQuery;
let scope: any;

describe("ThemisComponents: Component: DataGrid", () => {
  beforeEach(angular.mock.module("ThemisComponents"));

  beforeEach(inject((
    DataSource: DataSource,
    _DataGridService_: DataGridService,
    _$componentController_: angular.IComponentControllerService,
  ) => {
    dataGridService = _DataGridService_;
    $componentController = _$componentController_;
    dataGridComponentCtrl = null;
    scope = {
      opts: {
        columns: staticColumns,
        dataSource: DataSource.createDataSource({ data: staticData }),
      },
    };

    spyOn(dataGridService, "create");
    dataGridServiceCreateSpy = dataGridService.create as jasmine.Spy;
  }));

  afterEach(() => {
    if (element) {
      element.remove();
    }
  });

  describe("when options is specified: ", () => {
    it("creates a data grid", () => {
      const dataGrid = `<th-data-grid options="opts"></th-data-grid>`;
      dataGridServiceCreateSpy.and.callThrough();

      element = SpecHelpers.compileDirective(dataGrid, scope).element;
      expect(element.find(".k-grid-content table").length).toEqual(1);
    });
  });

  describe("#$onInit: ", () => {
    const locals = { $element: angular.element("<div>") };

    describe("With options.selectable specified: ", () => {
      beforeEach(() => {
        const options = { ...scope.opts, selectable: true };
        dataGridComponentCtrl = $componentController(componentName, locals, { options }) as DataGrid;
        dataGridComponentCtrl.$onInit();
      });

      it("calls the DataGridService.create with the columns and databound properties", () => {
        expect(dataGridServiceCreateSpy.calls.count()).toBe(1);

        const createOptions = dataGridServiceCreateSpy.calls.argsFor(0)[1];
        expect(createOptions.columns.length).toBe(scope.opts.columns.length + 1);
        expect(typeof createOptions.onDataBound).toBe("function");
      });
    });

    describe("Without options.selectable specified: ", () => {
      beforeEach(() => {
        const options = scope.opts;
        dataGridComponentCtrl = $componentController(componentName, locals, { options }) as DataGrid;
        dataGridComponentCtrl.$onInit();
      });

      it("calls the DataGridService.create with the columns and databound properties", () => {
        expect(dataGridServiceCreateSpy.calls.count()).toBe(1);

        const createOptions = dataGridServiceCreateSpy.calls.argsFor(0)[1];
        expect(createOptions.columns.length).toBe(scope.opts.columns.length);
        expect(createOptions.onDataBound).toBeUndefined();
      });
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

      dataGridComponentCtrl = $componentController(componentName, locals, { options }) as DataGrid;
      dataGridComponentCtrl.$onInit();
      setVisibleRowCallback = dataGridServiceCreateSpy.calls.argsFor(0)[1].onDataBound;
      setVisibleRowCallback(visibleRows);
    });

    it("sets the correct properties when no rows are selected", () => {
      dataGridComponentCtrl.selectedRows = [];
      dataGridComponentCtrl.updateHeaderCheckboxState();

      expect(dataGridComponentCtrl.partialPageSelected).toBe(false);
      expect(dataGridComponentCtrl.wholePageSelected).toBe(false);
    });

    it("sets the correct properties when some rows are selected", () => {
      dataGridComponentCtrl.selectedRows = [true, true];
      dataGridComponentCtrl.updateHeaderCheckboxState();

      expect(dataGridComponentCtrl.partialPageSelected).toBe(true);
      expect(dataGridComponentCtrl.wholePageSelected).toBe(false);
    });

    it("sets the correct properties when all rows are selected", () => {
      dataGridComponentCtrl.selectedRows = [true, true, true, true, true, true];
      dataGridComponentCtrl.updateHeaderCheckboxState();

      expect(dataGridComponentCtrl.partialPageSelected).toBe(false);
      expect(dataGridComponentCtrl.wholePageSelected).toBe(true);
    });

    it("calls the onSelectionChange callback", () => {
      dataGridComponentCtrl.updateHeaderCheckboxState();
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

      dataGridComponentCtrl = $componentController(componentName, locals, { options }) as DataGrid;
      dataGridComponentCtrl.$onInit();
      setVisibleRowCallback = dataGridServiceCreateSpy.calls.argsFor(0)[1].onDataBound;
      setVisibleRowCallback(visibleRows);
      spyOn(dataGridComponentCtrl, "updateHeaderCheckboxState");
    });

    it("sets all visible rows as selected when no rows are selected", () => {
      dataGridComponentCtrl.selectedRows = [];
      dataGridComponentCtrl.togglePage();
      expect(dataGridComponentCtrl.selectedRows).toEqual(allSelected);
    });

    it("sets all visible rows as selected when partial rows are selected", () => {
      dataGridComponentCtrl.selectedRows = [false, true, true];
      dataGridComponentCtrl.togglePage();
      expect(dataGridComponentCtrl.selectedRows).toEqual(allSelected);
    });

    it("sets all visible rows as unselected when all rows are selected", () => {
      dataGridComponentCtrl.selectedRows = allSelected;
      dataGridComponentCtrl.togglePage();
      expect(dataGridComponentCtrl.selectedRows).toEqual(noneSelected);
    });

    it("calls updateHeaderCheckboxState", () => {
      dataGridComponentCtrl.togglePage();
      expect(dataGridComponentCtrl.updateHeaderCheckboxState as jasmine.Spy).toHaveBeenCalled();
    });
  });

  describe("#clearSelection: ", () => {
    beforeEach(() => {
      const locals = { $element: angular.element("<div>") };
      const options = { ...scope.opts, selectable: true };

      dataGridComponentCtrl = $componentController(componentName, locals, { options }) as DataGrid;
      spyOn(dataGridComponentCtrl, "updateHeaderCheckboxState");
    });

    it("clears the selected rows collection", () => {
      dataGridComponentCtrl.selectedRows = [true, true, true];
      dataGridComponentCtrl.clearSelection();
      expect(dataGridComponentCtrl.selectedRows).toEqual([]);
    });

    it("calls updateHeaderCheckboxState", () => {
      dataGridComponentCtrl.clearSelection();
      expect(dataGridComponentCtrl.updateHeaderCheckboxState as jasmine.Spy).toHaveBeenCalled();
    });
  });
});
