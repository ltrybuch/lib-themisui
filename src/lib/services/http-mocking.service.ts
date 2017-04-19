// #missing-type-definition
const xhook: any = require("xhook");

// TODO: This probably needs sorting out to enforce functions that return
let Utilities: any = {};

/**
 * Take a request body (e.g. POST) data and place it on the response body
 * @param requestBody
 */
Utilities.copyRequestBodyToResponseBody = function(
  requestBody: string,
) {
  try {
    return JSON.parse(requestBody); // try parsing body as JSON
  } catch (exception) {
    let responseObj: any = {};
    // if JSON failed, try parsing as URI encoded params.
    const keyValRegExp = /(\w+)=(\w+)/g;
    let match = keyValRegExp.exec(requestBody);

    while (match != null) {
      responseObj[match[1]] = match[2];
      match = keyValRegExp.exec(requestBody);
    }
    return responseObj;
  }
};

/**
 * The fakeResponse function allows you to intercept HTTP requests and stub their responses.
 *
 * @param urlPattern The pattern to match the HTTP request.
 * @param responseStub The new HTTP response.
 */
const fakeResponse = function(
  urlPattern: RegExp,
  responseStub: { data?: { id?: number } },
  method: string = "GET",
) {
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
        responseStub = Utilities.copyRequestBodyToResponseBody(request.body);

        // Emulate a server returning a new id for a created resource
        if (method === "POST") {
          /**
           * Break the coupling to { data: { id: number } } structure
           * #coupled-to-clio
           */
            responseStub.data.id = Math.floor(Math.random() * (1000 - 1)) + 1;
        }
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
