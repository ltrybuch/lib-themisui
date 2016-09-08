angular.module "ThemisComponents"
.factory "InputFilter", (FilterBase) ->
  class InputFilter extends FilterBase
    constructor: (options = {}, initialState) ->
      super options
      @placeholder = options.placeholder
      @model = initialState?.value

    type: "input"

    getState: =>
      if @model?.length > 0
        return {
          value: @model
        }
      else return null

    clearState: =>
      @model = null
