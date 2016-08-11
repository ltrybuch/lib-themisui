angular.module "ThemisComponents"
.factory "AutocompleteFilter", (FilterBase) ->
  class AutocompleteFilter extends FilterBase
    constructor: (options = {}) ->
      super options
      @placeholder = options.placeholder
      @model = null
      @trackField = options.autocompleteOptions?.trackField or "id"

    type: "autocomplete"

    getValue: => @model?[@trackField] or null

    clearValue: => @model = null
