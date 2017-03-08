export default class Utilities {
  /* @ngInject */
  constructor(
    public $timeout: angular.ITimeoutService
  ) {}

  public onChange(callback: () => void) {
    return this.$timeout(() => {
      callback();
    });
  }

  /*
    * Temporarily changes a given element's style and returns
    * its calculated height.
    * Will return 0 if the given parameter is not an element.
    * @param  {element} element Element used to calculate height
    * @return {number}          Height in pixels
  */
  public getElementActualHeight(element: HTMLElement) {
    if (element instanceof Element === false) {
      return 0;
    }

    const previousCss = element.getAttribute("style");
    element.style.position = "absolute";
    element.style.visibility = "hidden";
    element.style.maxHeight = "none";
    element.style.transition = "initial";
    const height = element.offsetHeight;
    element.setAttribute("style", previousCss || "");

    return height;
  }
}
