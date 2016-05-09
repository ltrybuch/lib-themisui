angular.module "ThemisComponents"
.factory "InputFilter", (FilterBase) ->
  class InputFilter extends FilterBase
    constructor: (options = {}) ->
      super options
      @placeholder = options.placeholder
      @model = null

    type: "input"

    getValue: =>
      @model
