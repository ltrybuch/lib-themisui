FilterSetFactory = require("./filters/filterSet.service").default

class CustomFilters
  MAX_API_RESULTS = 200

  ###@ngInject###
  constructor: (@CustomFilterConverter, @$http, @$timeout, @DataSource) ->
    @customFilterRows = []
    @_nextIdentifier = 0

  $onInit: ->
    {customFilterUrl, customFilterConverter} = @thFilterCtrl.options
    @name = @thFilterCtrl.options.name
    @initialState = @thFilterCtrl.options.initialState
    @customFilterTypes = @thFilterCtrl.options.customFilterTypes

    @customFilterTypesDataSource = null

    @filterSet = @thFilterCtrl.options.filterSet
    @showSearchHint = @thFilterCtrl.options.showSearchHint

    unless @filterSet instanceof FilterSetFactory
      throw new Error "thCustomFilters: must specify 'filterSet'."

    unless @customFilterTypes instanceof Array or customFilterUrl?
      throw new Error "thCustomFilters: must specify 'customFilterTypes' or 'customFilterUrl'."

    @registerFilterInit customFilterUrl, customFilterConverter

  addCustomFilterRow: ->
    @customFilterRows.push
      identifier: @_getNextIdentifier()

  registerFilterInit: (customFilterUrl, customFilterConverter) ->
    @customFilterTypesDataSource = @DataSource.createDataSource
      serverFiltering: true
      schema:
        data: "data"
      transport:
        read: (e) =>
          if customFilterUrl?
            customFilterUrlPlusParams = customFilterUrl
            if e.data?.filter?.filters[0]
              customFilterUrlPlusParams += "&query=#{e.data.filter.filters[0].value}"

            @$http.get customFilterUrlPlusParams
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

                e.success data: @customFilterTypes
              , ->
                e.error()
          else
            e.success data: @customFilterTypes

    @thFilterCtrl.registerInitPromise @getInitialData @customFilterTypesDataSource

  getInitialData: (dataSource) ->
    return new Promise (resolve, reject) =>
      dataSource.fetch().then =>
        @$timeout =>
          @_disableServerFilteringIfNoFurtherPagesOfResults @customFilterTypes,
            dataSource,
            MAX_API_RESULTS

        @parseParams()
        resolve()
      , ->
        reject()

  _disableServerFilteringIfNoFurtherPagesOfResults: (
    customFilterTypes,
    customFilterTypesDataSource,
    max
  ) ->
    if customFilterTypes.length < max
      customFilterTypesDataSource.options.serverFiltering = false

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

  shouldShowComponent: =>
    @customFilterTypes?.length > 0 or @customFilterRows?.length > 0

angular.module "ThemisComponents"
.component "thCustomFilters",
  require:
    thFilterCtrl: "^thFilter"
  controllerAs: "thCustomFilters"
  template: require "./thCustomFilters.template.html"
  controller: CustomFilters
