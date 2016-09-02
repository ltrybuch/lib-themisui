angular.module 'ThemisComponents'
.directive 'thSearchRow', (InputFilter, $timeout) ->
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
        initialState
      } = scope.thSearchRow.options or thFilterController?.options

      unless filterSet instanceof Array
        throw new Error "thSearchRow: must specify 'filterSet' attribute."
      scope.thSearchRow.filterSet = filterSet

      scope.thSearchRow.initialValue =
        initialState?[scope.thSearchRow.queryFilterOptions.fieldIdentifier]

      thFilterController?.registerInitPromise new Promise (resolve) ->
        $timeout -> resolve()
