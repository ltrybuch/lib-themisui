angular.module 'ThemisComponents'
  .directive 'thFilterAutocomplete', (AutocompleteFilter) ->
    restrict: 'E'
    scope:
      filterSet: '='
      filterOptions: '='
      placeholder: '@'
      initialState: "=?"
    bindToController: true
    controllerAs: 'thFilterAutocomplete'
    template: require './thFilter.autocomplete.template.html'
    controller: ($scope, $injector) ->
      unless @filterOptions.autocompleteOptions?.modelClass
        throw new Error "thFilterAutocomplete: must specify " + \
          "'modelClass' in autocomplete options."

      try
        ModelClass = $injector.get @filterOptions.autocompleteOptions.modelClass
        dataSource = ModelClass.create()
      catch
        throw new Error "thFilterAutocomplete: cannot inject class '" + \
          "#{@filterOptions.autocompleteOptions.modelClass}'."

      fieldIdentifier =
        @filterOptions.autocompleteOptions?.queryField or "query"

      @displayField = @filterOptions.autocompleteOptions?.displayField or "name"
      @trackField = @filterOptions.autocompleteOptions?.trackField or "id"

      @combobox = @filterOptions.autocompleteOptions?.combobox or "false"
      @multiple = @filterOptions.autocompleteOptions?.multiple or "false"

      @rowTemplate = @filterOptions.autocompleteOptions?.rowTemplate or undefined

      @delegate = {
        displayField: @displayField
        trackField: @trackField
        dataSource: dataSource
      }

      $scope.$on "thFilter:destroyed", =>
        @filterSet.remove @filter

        if @filter.getState()?
          @filterSet.onFilterChange()

      $scope.$on "th.filters.clear", =>
        @filter.clearState()

      return
    compile: ->
      pre: (scope, element, attrs, controller) ->
        controller.filter = new AutocompleteFilter(
          controller.filterOptions
          controller.initialState
          controller.displayField
          controller.trackField
        )
        controller.filterSet.push controller.filter
