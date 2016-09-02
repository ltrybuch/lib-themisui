angular.module "ThemisComponents"
.factory "SelectFilter", ($http, FilterBase) ->
  class SelectFilter extends FilterBase
    constructor: (options = {}, selectOptionsOverride, initialValue) ->
      super options
      @placeholder = options.placeholder
      @options = selectOptionsOverride or options.selectOptions or []
      @model = null
      @nameField = options.selectOptionsNameField or "name"
      @valueField = options.selectOptionsValueField or "value"

      if options.selectOptionsUrl?
        @model = {}
        @model[@valueField] = initialValue

        $http
          method: 'GET'
          url: options.selectOptionsUrl
        .then (response) =>
          @options = if options.selectOptionsCallback?
            options.selectOptionsCallback response.data
          else
            response.data?.data?.map (item) =>
              name: item[@nameField]
              value: item[@valueField]

          if initialValue then @setOption initialValue
      else
        if initialValue then @setOption initialValue

    type: "select"

    setOption: (value) =>
      @model = @options.find (item) =>
        item[@valueField].toString() is value

    getValue: =>
      @model?[@valueField]

    clearValue: =>
      @model = null
