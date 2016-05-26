angular.module "ThemisComponents"
.directive "thCustomFilters", ($http, CustomFilterConverter) ->
  restrict: "E"
  scope:
    options: "="
  bindToController: true
  controllerAs: "thCustomFilters"
  template: require "./thCustomFilters.template.html"
  controller: ->
    {
      @filterSet
      @customFilterTypes
      customFilterUrl
      customFilterConverter
    } = @options

    unless @filterSet instanceof Array
      throw new Error "thCustomFilters: must specify 'filterSet' attribute."

    unless @customFilterTypes instanceof Array or customFilterUrl?
      throw new Error "thCustomFilters: must specify custom filter options " + \
                      "through 'customFilterTypes' or 'customFilterUrl'."

    if customFilterUrl?
      $http
        method: 'GET'
        url: customFilterUrl
      .then (response) =>
        if customFilterConverter?
          unless customFilterConverter.constructor.prototype instanceof CustomFilterConverter
            throw new Error "customFilterConverter must be instance of " + \
                            "'CustomFilterConverter'."

          @customFilterTypes = customFilterConverter.mapToCustomFilterArray response.data
        else
          @customFilterTypes = response.data

    @customFilterRows = []
    nextIdentifer = 0

    @addCustomFilterRow = =>
      @customFilterRows.push nextIdentifer
      nextIdentifer = nextIdentifer + 1

    @removeCustomFilterRow = (identifer) =>
      index = @customFilterRows.indexOf parseInt(identifer, 10)
      unless index > -1
        throw new Error "thCustomFilters: Cannot find custom filter " + \
                        "identifier."

      @customFilterRows.splice(index, 1)

    return
