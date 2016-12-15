angular.module "ThemisComponents"
.factory "AutocompleteFilter", (FilterBase) ->
  class AutocompleteFilter extends FilterBase
    constructor: (options = {}, initialState, displayField = "name", trackField = "id") ->
      super options
      @placeholder = options.placeholder
      @model = null
      @displayField = displayField
      @trackField = trackField

      if initialState
        @model = {}
        @model[@displayField] = initialState.name
        @model[@trackField] = initialState.value

    type: "autocomplete"

    getState: =>
      if @model
        return {
          name: @model[@displayField]
          value: @model[@trackField]
        }
      else return null

    clearState: => @model = null
