angular.module 'ThemisComponents'
  .directive 'thSearchRow', (InputFilter) ->
    restrict: 'E'
    scope:
      options: "="
      fieldIdentifier: "@?"
    bindToController: true
    controllerAs: 'thSearchRow'
    template: require './thSearchRow.template.html'
    controller: ->
      {
        @filterSet
      } = @options

      unless @filterSet instanceof Array
        throw new Error "thSearchRow: must specify 'filterSet' attribute."

      @queryFilterOptions = {
        fieldIdentifier: @fieldIdentifier or "query"
        placeholder: 'Enter search term...'
      }

      return
