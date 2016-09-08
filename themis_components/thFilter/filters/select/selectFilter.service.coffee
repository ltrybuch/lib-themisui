angular.module "ThemisComponents"
.factory "SelectFilter", ($http, FilterBase) ->
  class SelectFilter extends FilterBase
    constructor: (options = {}, selectOptionsOverride, initialState) ->
      super options
      @placeholder = options.placeholder
      @options = selectOptionsOverride or options.selectOptions or []
      @model = null
      @nameField = options.selectOptionsNameField or "name"
      @valueField = options.selectOptionsValueField or "value"

      if options.selectOptionsUrl?
        @model = {}
        @model[@valueField] = initialState?.value

        $http
          method: 'GET'
          url: options.selectOptionsUrl
        .then (response) =>
          @options = if options.selectOptionsCallback
            options.selectOptionsCallback response.data
          else
            response.data?.data?.map (item) =>
              name: item[@nameField]
              value: item[@valueField]

          if initialState then @setOption initialState.value
      else
        if initialState then @setOption initialState.value

    type: "select"

    setOption: (value) =>
      @model = @options.find (item) =>
        item[@valueField].toString() is value

    getState: =>
      if @model
        return {
          value: @model[@valueField]
        }
      else return null

    clearState: =>
      @model = null
