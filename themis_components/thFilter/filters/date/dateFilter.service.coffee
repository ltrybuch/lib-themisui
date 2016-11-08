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

      if @operatorOptions?
        unless @operatorOptions instanceof Array and @operatorOptions.length > 0
          throw new Error "DateFilter: must specify operator options of type Array."

        if @defaultOperatorIndex? and @defaultOperatorIndex >= @operatorOptions.length
          throw new Error "DateFilter: must specify valid default operator index."

      if initialState?
        @model = moment initialState.value
        @operator = @operatorOptions?.find (item) ->
          item.value is initialState.operator

        if @operatorOptions? and initialState.operator? and not @operator?
          throw new Error "DateFilter: must specify valid initial operator."

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
