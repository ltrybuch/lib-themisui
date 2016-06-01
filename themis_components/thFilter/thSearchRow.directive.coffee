angular.module 'ThemisComponents'
.directive 'thSearchRow', (InputFilter) ->
  restrict: 'E'
  require: "?^^thFilter"
  scope:
    options: "="
    fieldIdentifier: "@?"
  bindToController: true
  controllerAs: 'thSearchRow'
  template: require './thSearchRow.template.html'
  controller: ($scope) ->
    @queryFilterOptions = {
      fieldIdentifier: @fieldIdentifier or "query"
      placeholder: 'Enter search term...'
    }

    return
  compile: ->
    pre: (scope, element, attrs, thFilterController) ->
      {
        filterSet
      } = scope.thSearchRow.options or thFilterController.options

      unless filterSet instanceof Array
        throw new Error "thSearchRow: must specify 'filterSet' attribute."
      scope.thSearchRow.filterSet = filterSet
