FilterSetFactory = require("./filters/filterSet.service").default

angular.module "ThemisComponents"
.directive "thStaticFilters", ($timeout) ->
  restrict: "E"
  require: "^thFilter"
  scope:
    options: "="
  bindToController: true
  controllerAs: "thStaticFilters"
  template: require "./thStaticFilters.template.html"
  controller: -> return
  compile: ->
    pre: (scope, element, attrs, thFilterController) ->
      {
        filterSet
        staticFilters
        initialState
      } = thFilterController?.options


      unless filterSet instanceof FilterSetFactory
        throw new Error "thStaticFilters: options must specify 'filterSet'."

      unless staticFilters instanceof Array
        throw new Error "thStaticFilters: options must specify 'staticFilters'."

      scope.thStaticFilters.filterSet = filterSet

      scope.thStaticFilters.staticFilters = []
      staticFilters.forEach (item) ->
        state = initialState?[item.fieldIdentifier]
        scope.thStaticFilters.staticFilters.push
          filterOptions: item
          initialState: state

      thFilterController?.registerInitPromise new Promise (resolve) ->
        $timeout -> resolve()
