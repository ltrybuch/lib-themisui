angular.module "ThemisComponents"
.factory "SelectFilter", ($http, FilterBase) ->
  class SelectFilter extends FilterBase
    constructor: (options = {}) ->
      super options
      @placeholder = options.placeholder
      @options = options.selectOptions ? []
      @model = null

      if options.selectOptionsUrl?
        $http
          method: 'GET'
          url: options.selectOptionsUrl
        .then (response) =>
          @options = response.data.map (item) ->
            name: item[options.selectOptionsNameField or "name"]
            value: item[options.selectOptionsValueField or "value"]

    type: "select"

    getValue: =>
      @model?.value
