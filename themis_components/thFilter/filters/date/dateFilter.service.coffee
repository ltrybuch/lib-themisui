moment = require "moment"

angular.module "ThemisComponents"
.factory "DateFilter", (FilterBase) ->
  class DateFilter extends FilterBase
    constructor: (
      options = {}
      @operatorOptions = null
      @defaultOperatorIndex = 0
      initialState
    ) ->
      super options
      @placeholder = options.placeholder

      @clearState()

      if initialState?
        @model = moment initialState.value
        @operator = @operatorOptions?.find (item) ->
          item.value is initialState.operator

    type: "date"

    getState: =>
      if @model?.isValid
        state = {value: @model.format()}

        if @operator?.value?
          state.operator = @operator.value

        return state
      else return null

    clearState: =>
      @model = null
      @operator = @operatorOptions?[@defaultOperatorIndex]
