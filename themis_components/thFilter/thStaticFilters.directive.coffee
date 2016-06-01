angular.module "ThemisComponents"
.directive "thStaticFilters", (FilterSet) ->
  restrict: "E"
  require: "?^^thFilter"
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
      } = scope.thStaticFilters.options or thFilterController.options

      unless filterSet instanceof Array
        throw new Error "thStaticFilters: options must specify 'filterSet'."
      scope.thStaticFilters.filterSet = filterSet

      unless staticFilters instanceof Array
        throw new Error "thStaticFilters: options must specify 'staticFilters'."
      scope.thStaticFilters.staticFilters = staticFilters

      return
