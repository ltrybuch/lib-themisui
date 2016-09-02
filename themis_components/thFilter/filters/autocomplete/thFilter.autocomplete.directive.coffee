angular.module 'ThemisComponents'
  .directive 'thFilterAutocomplete', (AutocompleteFilter) ->
    restrict: 'E'
    scope:
      filterSet: '='
      filterOptions: '='
      placeholder: '@'
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

      @delegate =
        trackField: @filterOptions.autocompleteOptions?.trackField or "id"
        displayField: @filterOptions.autocompleteOptions?.displayField or "name"
        fetchData: ({searchString}, updateData) =>
          if searchString?.length > 1
            params = @filterOptions.autocompleteOptions.queryParams or {}
            params[fieldIdentifier] = searchString
            ModelClass.query(params).promise.then ({collection}) ->
              updateData collection
          else
            updateData []

      $scope.$on "$destroy", =>
        @filterSet.remove @filter

        if @filter.getValue()?
          @filterSet.onFilterChange()

      $scope.$on "th.filters.clear", =>
        @filter.clearValue()

      return
    compile: ->
      pre: (scope, element, attrs, controller) ->
        controller.filter = new AutocompleteFilter controller.filterOptions
        controller.filterSet.push controller.filter
