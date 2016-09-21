moment = require "moment"

angular.module "ThemisComponents"
  .factory "TimeFilter", (FilterBase) ->
    class TimeFilter extends FilterBase
      constructor: (
        options = {}
        operatorOptions = []
        defaultOperatorIndex = 0
        initialState
      ) ->
        super options
        @placeholder = options.placeholder

        unless operatorOptions instanceof Array and operatorOptions.length > 0
          throw new Error "TimeFilter: must specify operator options of type Array."
        @operatorOptions = operatorOptions

        unless defaultOperatorIndex < operatorOptions.length
          throw new Error "TimeFilter: must specify valid default operator index."
        @defaultOperatorIndex = defaultOperatorIndex

        @clearState()

        if initialState
          @model = initialState.value
          @operator = @operatorOptions.find (item) ->
            item.value is initialState.operator
          @validate()

      type: "time"

      validate: =>
        if @model?.length > 0
          @time = moment(@model,
            [
              "H:ma"
              "Hma"
              "H:m a"
              "Hm a"
              "Ha"
              "H a"
              "H:m"
              "Hm"
              "H"
            ]
            true
          )
          if @time.isValid()
            @model = @time.format "h:mm A"
            return true
          else
            @time = null
            return false
        else
          @time = null
          return true

      getState: =>
        if @time
          return {
            value: @time.format "H:mm"
            operator: @operator.value
          }
        else return null

      clearState: =>
        @model = @time = null
        @operator = @operatorOptions[@defaultOperatorIndex]
