import { fakeResponse } from "../../../services/http-mocking.service";
import { fakeDataObj as expectedDataObj } from "../../tests/fixtures/tabledata";

function generateFakeResponseWithPageSize(url: string, pageSize: number) {

  function containsQuery(query: string, ...searchItems: string[]) {
    const lowercaseQuery = query.toLowerCase();
    return searchItems.some(item => {
      return item.toLowerCase().indexOf(lowercaseQuery) > -1;
    });
  }

  function randomizeOrder(data: any[]) {
    return data.slice(0).sort(() => Math.random() * 2 - 1);
  }

  for (let i = 0; i < expectedDataObj.total; i += pageSize) {
    const page = Math.floor(i / pageSize) + 1;
    const regExp = new RegExp(`^${url}.*page=${ page }.*limit=${ pageSize }`, "g");

    fakeResponse(regExp, url => {
      const query = url.match(/.*query=([^&]+)/);

      if (query && query[1]) {
        const filteredExpectedDataObject = expectedDataObj.items
          .filter(item => containsQuery(query[1], item.FirstName, item.LastName));

        return {
          total: filteredExpectedDataObject.length,
          items: randomizeOrder(filteredExpectedDataObject.slice(i, (i + pageSize))),
        };
      }

      return {
        total: expectedDataObj.total,
        items: randomizeOrder(expectedDataObj.items.slice(i, (i + pageSize))),
      };
    });
  }
}

export default generateFakeResponseWithPageSize;
