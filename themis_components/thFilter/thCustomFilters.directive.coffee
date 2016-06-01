angular.module "ThemisComponents"
.directive "thCustomFilters", ($http, CustomFilterConverter) ->
  restrict: "E"
  require: "?^^thFilter"
  scope:
    options: "="
  bindToController: true
  controllerAs: "thCustomFilters"
  template: require "./thCustomFilters.template.html"
  controller: ->
    @customFilterRows = []
    nextIdentifer = 0

    @addCustomFilterRow = ->
      @customFilterRows.push nextIdentifer
      nextIdentifer = nextIdentifer + 1

    @removeCustomFilterRow = (identifer) ->
      index = @customFilterRows.indexOf parseInt(identifer, 10)
      unless index > -1
        throw new Error "thCustomFilters: Cannot find custom filter " + \
                        "identifier."

      @customFilterRows.splice(index, 1)

    return
  compile: ->
    pre: (scope, element, attrs, thFilterController) ->
      {
        filterSet
        customFilterTypes
        customFilterUrl
        customFilterConverter
      } = scope.thCustomFilters.options or thFilterController.options

      unless filterSet instanceof Array
        throw new Error "thCustomFilters: must specify 'filterSet'."
      scope.thCustomFilters.filterSet = filterSet

      unless customFilterTypes instanceof Array or customFilterUrl?
        throw new Error "thCustomFilters: must specify 'customFilterTypes'" + \
                        "or 'customFilterUrl'."
      scope.thCustomFilters.customFilterTypes = customFilterTypes

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
