thTableKeyboardNavigation = require "./thTableKeyboardNavigation"

angular.module "ThemisComponents"
  .directive "thTable", ($compile, Table) ->
    restrict: "E"
    scope:
      delegate: "="
    bindToController: true
    controllerAs: "thTable"
    controller: ($scope, $element) ->
      thTableKeyboardNavigation $element, $scope

      @mouseOver = (event) ->
        eventRows = getEventRows event
        angular.element(eventRows.hoverRow).addClass "th-table-hover-row"
        angular.element(eventRows.partnerRow).addClass "th-table-hover-row"
        return

      @mouseLeave = (event) ->
        eventRows = getEventRows event
        angular.element(eventRows.hoverRow).removeClass "th-table-hover-row"
        angular.element(eventRows.partnerRow).removeClass "th-table-hover-row"
        return

      getEventRows = (event) ->
        hoverRow = angular.element(event.target).closest "tr"
        partnerRow =
          if angular.element(hoverRow).hasClass "th-table-cells-row"
            nextRow = angular.element(hoverRow).next()
            nextRow if nextRow.hasClass "th-table-actions-row"
          else if angular.element(hoverRow).hasClass "th-table-actions-row"
            hoverRow.previousElementSibling
        return {hoverRow, partnerRow}

      return

    compile: (element, attrs) ->
      table = Table {element: element[0]}
      table.clear()

      return post: (scope, element, attrs, controller) ->
        table.setDelegate controller.delegate
        template = table.generateTableTemplate()

        # The scope used for the table template will be a child of thTable's
        # scope that inherits from thTable's parent scope.
        #
        # This is so that the contents of <th-table-row>s have access to the
        # outside scope, as if they were transcluded.
        childScope = scope.$parent.$new false, scope

        # We are attaching the table's controller to the scope, so that the
        # template has access to it.
        childScope.thTable = scope.thTable

        compiledTemplate = $compile(template) childScope
        element.append compiledTemplate
