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
      catch
        throw new Error "thFilterAutocomplete: cannot inject class '" + \
          "#{@filterOptions.autocompleteOptions.modelClass}'."

      fieldIdentifier =
        @filterOptions.autocompleteOptions?.queryField or "query"

      @displayField = @filterOptions.autocompleteOptions?.displayField or "name"
      @trackField = @filterOptions.autocompleteOptions?.trackField or "id"

      @delegate = {
        @displayField
        @trackField
        fetchData: ({searchString}, updateData) =>
          if searchString?.length > 1
            params = @filterOptions.autocompleteOptions.queryParams or {}
            params[fieldIdentifier] = searchString
            ModelClass.query(params).promise.then ({collection}) ->
              updateData collection
          else
            updateData []
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
