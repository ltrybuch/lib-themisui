// https://developer.mozilla.org/en/docs/Web/JavaScript/Reference/Global_Objects/String/includes#Polyfill

if (!String.prototype.includes) {
  String.prototype.includes = function() {'use strict';
    return String.prototype.indexOf.apply(this, arguments) !== -1;
  };
}
