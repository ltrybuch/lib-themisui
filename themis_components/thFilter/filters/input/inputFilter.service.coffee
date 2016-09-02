angular.module "ThemisComponents"
.factory "InputFilter", (FilterBase) ->
  class InputFilter extends FilterBase
    constructor: (options = {}, initialValue) ->
      super options
      @placeholder = options.placeholder
      @model = initialValue

    type: "input"

    getValue: =>
      if @model?.length > 0 then @model else null

    clearValue: =>
      @model = null
