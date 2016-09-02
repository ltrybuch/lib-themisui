angular.module "ThemisComponents"
.directive "thFilter", (FilterSet, $q) ->
  restrict: "E"
  scope:
    options: "="
  bindToController: true
  transclude: true
  controllerAs: "thFilter"
  template: require "./thFilter.template.html"
  controller: ($scope, $element) ->
    @initPromises = []

    {
      @filterSet
    } = @options

    unless @filterSet instanceof Array
      throw new Error "thFilter: options must specify 'filterSet'."

    @registerInitPromise = (promise) ->
      @initPromises.push promise

    @clearFilters = ->
      $scope.$broadcast "th.filters.clear"
      @filterSet.onFilterChange()

    return

  link: (scope, element, attrs, thFilterController) ->
    $q.when(
      Promise.all scope.thFilter.initPromises
      ->
        scope.thFilter.filterSet.onInitialized?()
      ->
        console.log 'error'
    )
