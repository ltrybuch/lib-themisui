import * as angular from "angular";
import * as $ from "jquery";
import "@progress/kendo-ui/js/kendo.validator.js";

type validatorOptions = {
  element: HTMLElement,
  attrs: angular.IAttributes,
  rules?: any,
  messages?: any,
  validateInput: Function,
  customOptions?: {
    rules?: {
      [name: string]: () => void;
    },
    messages?: {
      [name: string]: string;
    }
  }
};

class ValidatorService {
  private options: any;

  create(options: validatorOptions) {
    const defaultOpts = {
      rules: {
        required: (ele: any) => {
          if (options.attrs.required) { // if ng-required is true, required attr would exist
            return ele[0].value; // if <input> has value, valid.
          } else { // if input not required, return valid
            return true;
          }
        }
      },
      messages: {
        required: "Required"
      }
    };

    this.options = $.extend(true, {}, defaultOpts, options, options.customOptions);

    const validator = new kendo.ui.Validator(options.element, {
      messages: this.options.messages,
      rules: this.options.rules,
    });
    validator.bind("validateInput", this.options.validateInput);

    return validator;
  }
}

export {validatorOptions, ValidatorService};
