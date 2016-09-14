moment = require "moment"

angular.module "ThemisComponents"
.factory "DateFilter", (FilterBase) ->
  class DateFilter extends FilterBase
    constructor: (options = {}) ->
      super options
      @placeholder = options.placeholder

    type: "date"

    getState: =>
      if @model?.isValid
        return {
          value: @model.format()
        }
      else return null

    clearState: =>
      @model = null
