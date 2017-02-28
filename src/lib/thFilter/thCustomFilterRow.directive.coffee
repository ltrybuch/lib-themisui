require './thCustomFilterRow.controller'

angular.module 'ThemisComponents'
  .directive 'thCustomFilterRow', ->
    restrict: 'E'
    require: "^thCustomFilters"
    scope:
      rowSelectValue: "="
      initialState: "=?"
      customFilterTypes: "="
      filterSet: "="
      onRemoveRow: "&"
      showSearchHint: "<"
    bindToController: true
    controllerAs: 'thCustomFilterRow'
    template: require './thCustomFilterRow.template.html'
    controller: "thCustomFilterRow.controller"
