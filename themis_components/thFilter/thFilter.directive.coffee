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
    scope.thFilter.isLoading = yes
    $q.when(
      Promise.all scope.thFilter.initPromises
      ->
        scope.thFilter.isLoading = no
        scope.thFilter.filterSet.onInitialized?()
      ->
        console.log 'thFilter: Some filters were unable to load.'
    )
