// #missing-type-definition
const xhook: any = require("xhook");
const keyValRegExp = /(\w+)=(\w+)/g;

// TODO: This probably needs sorting out to enforce functions that return
let Utilities: any = {};

/**
 * Take a request body (e.g. POST) data and place it on the response body
 * @param requestBody
 * @param responseStub
 */
Utilities.copyRequestBodyToResponseBody = function(
  requestBody: string,
  responseStub: { [item: string]: string },
) {
  let match = keyValRegExp.exec(requestBody);
  responseStub[match[1]] = match[2];
  while (match != null) {
    match = keyValRegExp.exec(requestBody);
    responseStub[match[1]] = match[2];
  }
};

/**
 * The fakeResponse function allows you to intercept HTTP requests and stub their responses.
 *
 * @param urlPattern The pattern to match the HTTP request.
 * @param responseStub The new HTTP response.
 */
const fakeResponse = function(urlPattern: RegExp, responseStub: { data?: object }, method: string = "GET"): void {
  xhook.before(function(request: { url: string, body?: string, method: string }) {
    if (request.url.match(urlPattern) && request.method === method) {

      // show AJAX request console logs in browser, to help developers remember not to check Network tab
      if (window.location.pathname.indexOf("context") === -1) {
        console.log(
          `%c AJAX request intercepted: ${request.url}`,
          "background: #222; color: #bada55",
          arguments,
          request,
        );
      }

      /**
       * We do this to make sure the client gets back what it expects from the server
       * ...an identical object to which it sent.
       * Kendo UI DataSource seems to change its client-side state if a POST response body
       * bears a different version of the object.
       */
      if (method === "POST" || method === "PATCH") {
        Utilities.copyRequestBodyToResponseBody(request.body, responseStub.data);
      }

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
