angular.module "ThemisComponents"
.factory "NumberFilter", (FilterBase) ->
  class NumberFilter extends FilterBase
    constructor: (
      options = {}
      operatorOptions = []
      defaultOperatorIndex = 0
      initialState
    ) ->
      super options
      @placeholder = options.placeholder

      unless operatorOptions instanceof Array and operatorOptions.length > 0
        throw new Error "NumberFilter: must specify operator options of type Array."
      @operatorOptions = operatorOptions

      unless defaultOperatorIndex < operatorOptions.length
        throw new Error "NumberFilter: must specify valid default operator index."
      @defaultOperatorIndex = defaultOperatorIndex

      @clearState()

      if initialState
        @model = initialState.value
        @operator = @operatorOptions.find (item) ->
          item.value is initialState.operator

    type: "number"

    getState: =>
      if @model
        return {
          value: @model
          operator: @operator.value
        }
      else return null

    clearState: =>
      @model = null
      @operator = @operatorOptions[@defaultOperatorIndex]
