import * as angular from "angular";
import "angular-mocks";
import { staticColumns } from "./fixtures/tabledata";
import { DataTable } from "../data-table.component";
import { DataTableService } from "../data-table.service";

const componentName = "thDataTable";
const pageData = [{"uid": "a"}, {"uid": "b"}, {"uid": "c"}];
let dataTableComponentCtrl: DataTable;
let dataTableService: DataTableService;
let dataTableServiceCreateSpy: jasmine.Spy;
let $componentController: angular.IComponentControllerService;
let element: JQuery;
let scope: any;

describe("ThemisComponents: Component: DataTable", () => {
  beforeEach(angular.mock.module("ThemisComponents"));

  beforeEach(inject((
    _DataTableService_: DataTableService,
    _$componentController_: angular.IComponentControllerService,
  ) => {
    dataTableService = _DataTableService_;
    $componentController = _$componentController_;
    dataTableComponentCtrl = null;
    scope = {
      opts: {
        columns: staticColumns,
        dataSource: {
          data: jasmine.createSpy("data"),
          view: jasmine.createSpy("view"),
          pageSize: jasmine.createSpy("pageSize"),
        },
        onSelectionChange: jasmine.createSpy("onSelectionChange"),
      },
    };

    spyOn(dataTableService, "getComponentOptions");
    dataTableServiceCreateSpy = dataTableService.getComponentOptions as jasmine.Spy;
  }));

  afterEach(() => {
    if (element) {
      element.remove();
    }
  });

  describe("#$onInit:", () => {
    const locals = { $element: angular.element("<div>") };

    describe("With options specified:", () => {
      beforeEach(() => {
        const dataTableUserOptions = scope.opts;
        dataTableComponentCtrl = $componentController(componentName, locals, { dataTableUserOptions }) as DataTable;
        scope.opts.dataSource.data.and.returnValue([]);
        scope.opts.dataSource.view.and.returnValue([]);
      });

      it("calls DataTableService.getComponentOptions", () => {
        dataTableComponentCtrl.$onInit();
        expect(dataTableServiceCreateSpy).toHaveBeenCalledTimes(1);
      });
    });
  });

  describe("#togglePage:", () => {
    const dictFalse = {"a": false, "b": false, "c": false};
    const dictTrue = {"a": true, "b": true, "c": true};

    beforeEach(() => {
      const locals = { $element: angular.element("<div>") };
      const dataTableUserOptions = scope.opts;
      dataTableComponentCtrl = $componentController(componentName, locals, { dataTableUserOptions }) as DataTable;
      scope.opts.dataSource.data.and.returnValue(pageData);
      scope.opts.dataSource.view.and.returnValue(pageData);

      dataTableComponentCtrl.$onInit();
    });

    it("selects all rows on page when wholePageSelected is true", () => {
      dataTableComponentCtrl.wholePageSelected = true;
      dataTableComponentCtrl.togglePage();

      expect(dataTableComponentCtrl.selectionStatusDict).toEqual(dictTrue);
    });

    it("clears selection when wholePageSelected is false", () => {
      dataTableComponentCtrl.wholePageSelected = false;
      dataTableComponentCtrl.togglePage();

      expect(dataTableComponentCtrl.selectionStatusDict).toEqual(dictFalse);
    });

    it("to call onSelectionChangeHandler", () => {
      dataTableComponentCtrl.togglePage();

      expect(scope.opts.onSelectionChange).toHaveBeenCalled();
    });
  });

  describe("#clearSelection:", () => {
    const dictPartial = {"a": false, "b": true, "c": false};
    const dictTrue = {"a": true, "b": true, "c": true};

    beforeEach(() => {
      const locals = { $element: angular.element("<div>") };
      const dataTableUserOptions = { ...scope.opts };
      dataTableComponentCtrl = $componentController(componentName, locals, { dataTableUserOptions }) as DataTable;
      scope.opts.dataSource.data.and.returnValue(pageData);
      scope.opts.dataSource.view.and.returnValue(pageData);

      dataTableComponentCtrl.$onInit();
    });

    it("clears selection when page is partially selected", () => {
      dataTableComponentCtrl.selectionStatusDict = dictPartial;
      dataTableComponentCtrl.clearSelection();

      expect(dataTableComponentCtrl.selectionStatusDict).toEqual({});
    });

    it("clears selection when page is all selected", () => {
      dataTableComponentCtrl.selectionStatusDict = dictTrue;
      dataTableComponentCtrl.clearSelection();

      expect(dataTableComponentCtrl.selectionStatusDict).toEqual({});
    });
  });

  describe("#getSelectedSize:", () => {
    beforeEach(() => {
      const locals = { $element: angular.element("<div>") };
      const dataTableUserOptions = { ...scope.opts };
      dataTableComponentCtrl = $componentController(componentName, locals, { dataTableUserOptions }) as DataTable;
      scope.opts.dataSource.data.and.returnValue(pageData);
      scope.opts.dataSource.view.and.returnValue(pageData);

      dataTableComponentCtrl.$onInit();
    });

    it("returns 0 when no items are selected", () => {
      dataTableComponentCtrl.selectionStatusDict = {};
      expect(dataTableComponentCtrl.getSelectedSize()).toBe(0);

      dataTableComponentCtrl.selectionStatusDict = {"a": false};
      expect(dataTableComponentCtrl.getSelectedSize()).toBe(0);
    });

    it("returns length when items are selected", () => {
      dataTableComponentCtrl.selectionStatusDict = {"a": true, "b": false};
      expect(dataTableComponentCtrl.getSelectedSize()).toBe(1);
    });
  });

  describe("#rowCheckboxClickHander:", () => {
    beforeEach(() => {
      const locals = { $element: angular.element("<div>") };
      const dataTableUserOptions = { ...scope.opts, selectable: true };

      dataTableComponentCtrl = $componentController(componentName, locals, { dataTableUserOptions }) as DataTable;
      scope.opts.dataSource.data.and.returnValue(pageData);
      scope.opts.dataSource.view.and.returnValue(pageData);
      scope.opts.dataSource.pageSize.and.returnValue(3);

      dataTableComponentCtrl.$onInit();
    });

    it("sets the correct properties when no rows are selected", () => {
      dataTableComponentCtrl.selectionStatusDict = {};
      dataTableComponentCtrl.rowCheckboxClickHander();

      expect(dataTableComponentCtrl.partialPageSelected).toBe(false);
      expect(dataTableComponentCtrl.wholePageSelected).toBe(false);
    });

    it("sets the correct properties when some rows are selected", () => {
      dataTableComponentCtrl.selectionStatusDict = {"a": true, "b": false};
      dataTableComponentCtrl.rowCheckboxClickHander();

      expect(dataTableComponentCtrl.partialPageSelected).toBe(true);
      expect(dataTableComponentCtrl.wholePageSelected).toBe(false);
    });

    it("sets the correct properties when all rows are selected", () => {
      dataTableComponentCtrl.selectionStatusDict = {"a": true, "b": true, "c": true};
      dataTableComponentCtrl.rowCheckboxClickHander();

      expect(dataTableComponentCtrl.partialPageSelected).toBe(false);
      expect(dataTableComponentCtrl.wholePageSelected).toBe(true);
    });

    it("to call onSelectionChangeHandler", () => {
      dataTableComponentCtrl.rowCheckboxClickHander();

      expect(scope.opts.onSelectionChange).toHaveBeenCalled();
    });
  });

});
