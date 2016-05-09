angular.module "ThemisComponents"
.factory "FilterBase", ->
  class FilterBase
    constructor: (options = {}) ->
      {
        fieldIdentifier
        name
      } = options

      @fieldIdentifier = fieldIdentifier
      @name = name

    getValue: ->
      throw new Error "FilterBase: Subclass '#{@type}' must implement " + \
                      "'getValue'."
