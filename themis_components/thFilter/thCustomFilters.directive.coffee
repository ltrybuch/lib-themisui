angular.module "ThemisComponents"
.directive "thCustomFilters", (CustomFilterConverter, $http, $timeout) ->
  restrict: "E"
  require: "?^^thFilter"
  scope:
    options: "="
  bindToController: true
  controllerAs: "thCustomFilters"
  template: require "./thCustomFilters.template.html"
  controller: ($scope) ->
    @customFilterRows = []
    nextIdentifier = 0

    getNextIdentifier = ->
      identifier = nextIdentifier
      nextIdentifier += 1
      identifier.toString()

    @addCustomFilterRow = ->
      @customFilterRows.push
        identifier: getNextIdentifier()

    @removeCustomFilterRow = (identifier) ->
      index = @customFilterRows.findIndex (item) ->
        item.identifier is identifier

      unless index > -1
        throw new Error "thCustomFilters: Cannot find custom filter " + \
                        "identifier."

      @customFilterRows.splice(index, 1)

    @parseParams = ->
      if @initialState
        for key in Object.keys @initialState
          type = @customFilterTypes.find (item) ->
            item.fieldIdentifier is key

          unless type? then continue

          @customFilterRows.push
            identifier: getNextIdentifier()
            type: type
            initialState: @initialState[key]

    return
  compile: ->
    pre: (scope, element, attrs, thFilterController) ->
      {
        filterSet
        customFilterTypes
        customFilterUrl
        customFilterConverter
        initialState
        name
      } = scope.thCustomFilters.options or thFilterController?.options

      scope.thCustomFilters.name = name
      scope.thCustomFilters.initialState = initialState

      unless filterSet instanceof Array
        throw new Error "thCustomFilters: must specify 'filterSet'."
      scope.thCustomFilters.filterSet = filterSet

      unless customFilterTypes instanceof Array or customFilterUrl?
        throw new Error "thCustomFilters: must specify 'customFilterTypes'" + \
                        "or 'customFilterUrl'."
      scope.thCustomFilters.customFilterTypes = customFilterTypes

      onInitializedSuccess = onInitializedFailure = null
      thFilterController?.registerInitPromise new Promise (resolve, reject) ->
        onInitializedSuccess = resolve
        onInitializedFailure = reject

      if customFilterUrl?
        $http
          method: 'GET'
          url: customFilterUrl
        .then (response) ->
          if customFilterConverter?
            unless customFilterConverter.constructor.prototype instanceof CustomFilterConverter
              throw new Error "customFilterConverter must be instance of " + \
                              "'CustomFilterConverter'."

            scope.thCustomFilters.customFilterTypes =
              customFilterConverter.mapToCustomFilterArray response.data
          else
            scope.thCustomFilters.customFilterTypes = response.data

          scope.thCustomFilters.parseParams()

          onInitializedSuccess?()
        , ->
          onInitializedFailure?()
      else
        scope.thCustomFilters.parseParams()

        $timeout ->
          onInitializedSuccess?()
