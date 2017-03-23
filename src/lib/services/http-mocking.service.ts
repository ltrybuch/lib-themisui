// #missing-type-definition
const xhook: any = require("xhook");

/**
 * The fakeResponse function allows you to intercept HTTP requests and stub their responses.
 *
 * @param urlPattern The pattern to match the HTTP request.
 * @param responseStub The new HTTP response.
 */
const fakeResponse = function(urlPattern: RegExp, responseStub: Object): void {
  xhook.before(function(request: { url: string }) {
    if (request.url.match(urlPattern)) {
      const jsonResponseText = JSON.stringify(responseStub);
      /**
       * We assign `data` AND `text` because some XHR requests are looking for one
       * or the other. #hacky-for-now
       */
      const obj = {
        data: jsonResponseText,
        status: 200,
        text: jsonResponseText,
      };
      return obj;
    }
  });
};

export {
  fakeResponse
}
