angular.module "ThemisComponents"
.directive "thCustomFilters", ->
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
    } = @options

    unless @filterSet instanceof Array
      throw new Error "thCustomFilters: must specify 'filterSet' attribute."

    unless @customFilterTypes instanceof Array
      throw new Error "thCustomFilters: filter options not valid."

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
