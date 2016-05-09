angular.module "ThemisComponents"
.directive "thStaticFilters", (FilterSet) ->
  restrict: "E"
  scope:
    options: "="
  bindToController: true
  controllerAs: "thStaticFilters"
  template: require "./thStaticFilters.template.html"
  controller: ($scope, $element) ->
    {
      @filterSet
      @staticFilters
    } = @options

    unless @filterSet instanceof Array
      throw new Error "thStaticFilters: must specify 'filterSet' attribute."

    unless @staticFilters instanceof Array
      throw new Error "thStaticFilters: must specify 'staticFilters'" + \
                      "attribute."

    return
