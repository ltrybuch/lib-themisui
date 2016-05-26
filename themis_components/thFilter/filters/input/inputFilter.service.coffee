angular.module "ThemisComponents"
.factory "InputFilter", (FilterBase) ->
  class InputFilter extends FilterBase
    constructor: (options = {}) ->
      super options
      @placeholder = options.placeholder
      @model = null

    type: "input"

    getValue: =>
      if @model?.length > 0 then @model else null

    clearValue: =>
      @model = null
