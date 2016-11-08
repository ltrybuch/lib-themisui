angular.module 'ThemisComponents'
  .factory 'Utilities', ($timeout) ->

    onChange = (callback) -> $timeout -> callback()

    ###*
     * Temporarily changes a given element's style and returns
     * its calculated height.
     * Will return 0 if the given parameter is not an element.
     * @param  {element} element Element used to calculate height
     * @return {number}          Height in pixels
    ###
    getElementActualHeight = (element) ->
      unless element instanceof Element
        return 0

      previousCss = element.getAttribute "style"
      element.style.position = "absolute"
      element.style.visibility = "hidden"
      element.style.maxHeight = "none"
      element.style.transition = "initial"
      height = element.offsetHeight

      element.setAttribute "style", previousCss or ""
      return height

    return {
      onChange
      getElementActualHeight
    }
