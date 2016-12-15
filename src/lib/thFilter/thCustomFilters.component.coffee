class CustomFilters
  ###@ngInject###
  constructor: (@CustomFilterConverter, @$http, @$timeout) ->
    @customFilterRows = []
    @_nextIdentifier = 0

  $onInit: ->
    {customFilterUrl, customFilterConverter} = @thFilterCtrl.options
    @name = @thFilterCtrl.options.name
    @initialState = @thFilterCtrl.options.initialState
    @customFilterTypes = @thFilterCtrl.options.customFilterTypes
    @filterSet = @thFilterCtrl.options.filterSet
    @showSearchHint = @thFilterCtrl.options.showSearchHint

    unless @filterSet instanceof Array
      throw new Error "thCustomFilters: must specify 'filterSet'."

    unless @customFilterTypes instanceof Array or customFilterUrl?
      throw new Error "thCustomFilters: must specify 'customFilterTypes' or 'customFilterUrl'."

    @registerFilterInit customFilterUrl, customFilterConverter

  addCustomFilterRow: ->
    @customFilterRows.push
      identifier: @_getNextIdentifier()

  registerFilterInit: (customFilterUrl, customFilterConverter) ->
    @thFilterCtrl.registerInitPromise new Promise (resolve, reject) =>
      if customFilterUrl?
        @$http.get customFilterUrl
          .then (response) =>
            if customFilterConverter?
              unless customFilterConverter.constructor.prototype instanceof @CustomFilterConverter
                throw new Error "customFilterConverter must be instance of 'CustomFilterConverter'."

              [@customFilterTypes, meta] =
                customFilterConverter.mapToCustomFilterArray response.data
              @showSearchHint = meta.showSearchHint
            else
              @customFilterTypes = response.data
              @showSearchHint = no

            @parseParams()
            resolve()
          , ->
            reject()
      else
        @parseParams()
        @$timeout -> resolve()

  removeCustomFilterRow: (identifier) ->
    index = @customFilterRows.findIndex (item) ->
      item.identifier is identifier

    unless index > -1
      throw new Error "thCustomFilters: Cannot find custom filter identifier."

    @customFilterRows.splice index, 1

  parseParams: ->
    if @initialState
      for key in Object.keys @initialState
        type = @customFilterTypes.find (item) ->
          item.fieldIdentifier is key

        unless type? then continue

        @customFilterRows.push
          identifier: @_getNextIdentifier()
          type: type
          initialState: @initialState[key]

  _getNextIdentifier: ->
    identifier = @_nextIdentifier
    @_nextIdentifier += 1
    identifier.toString()

angular.module "ThemisComponents"
.component "thCustomFilters",
  require:
    thFilterCtrl: "^thFilter"
  controllerAs: "thCustomFilters"
  template: require "./thCustomFilters.template.html"
  controller: CustomFilters