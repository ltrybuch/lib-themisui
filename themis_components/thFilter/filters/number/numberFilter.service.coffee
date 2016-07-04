angular.module "ThemisComponents"
.factory "NumberFilter", (FilterBase) ->
  class NumberFilter extends FilterBase
    constructor: (options = {}, operatorOptions  = [], defaultOperatorIndex = 0) ->
      super options
      @placeholder = options.placeholder

      unless operatorOptions instanceof Array and operatorOptions.length > 0
        throw new Error "NumberFilter: must specify operator options of type Array."
      @operatorOptions = operatorOptions

      unless defaultOperatorIndex < operatorOptions.length
        throw new Error "NumberFilter: must specify valid default operator index."
      @defaultOperatorIndex = defaultOperatorIndex

      @clearValue()

    type: "number"

    getValue: =>
      if @model?
        @operator.value + @model
      else
        null

    clearValue: =>
      @model = null
      @operator = @operatorOptions[@defaultOperatorIndex]
