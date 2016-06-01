angular.module "ThemisComponents"
.directive "thFilter", (FilterSet) ->
  restrict: "E"
  scope:
    options: "="
  bindToController: true
  transclude: true
  controllerAs: "thFilter"
  template: require "./thFilter.template.html"
  controller: ($scope, $element) ->
    {
      @filterSet
    } = @options

    unless @filterSet instanceof Array
      throw new Error "thFilter: options must specify 'filterSet'."

    @clearFilters = ->
      $scope.$broadcast "th.filters.clear"
      @filterSet.onFilterChange()

    return
