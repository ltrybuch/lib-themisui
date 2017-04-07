import * as angular from "angular";
import { fakeResponse } from "../../../services/http-mocking.service";
import { staticColumns, fakeDataObj as expectedDataObj } from "../../tests/fixtures/tabledata";

angular.module("thDataTableDemo")
  .controller("thDataTableDemoCtrl5", function(DataSource) {

    let dataSource = DataSource.createDataSource({
      transport: {
        read: {
          url: "url",
          dataType: "json",
        },
        parameterMap: function(data: {take: number, skip: number, page: number, pageSize: number}) {
          return {
            page: data.page,
            limit: data.pageSize,
          }
        },
      },
      schema: {
        data: "items",
        total: "total",
      },
      pageSize: 50,
      serverPaging: true,
    });

    this.options = {
      columns: staticColumns,
      dataSource: dataSource,
      selectable: true,
      pageable: {
        pageSizes: true,
      },
    };

  });

[50, 100, 150, 200].forEach((pageSize: number) => {
  generateFakeResponseWithPageSize(pageSize);
});

function generateFakeResponseWithPageSize(pageSize: number) {
  for (let i = 0; i < expectedDataObj.total; i+=pageSize) {
    const page = Math.floor(i/pageSize) + 1;
    const regExp = new RegExp(`page=${ page }.*limit=${ pageSize }`, "g");
    const expectedItemsObj = {
      total: expectedDataObj.total,
      items: expectedDataObj.items.slice(i, (i+pageSize)),
    }

    fakeResponse(regExp, expectedItemsObj);
  }
}
