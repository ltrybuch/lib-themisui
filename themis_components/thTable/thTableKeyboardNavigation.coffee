keycode = require "keycode"

module.exports = ($element, $scope) ->
  currentColumnIndex = undefined

  $element.on 'keydown', (event) ->
    if angular.element(event.target)[0].tagName is "TD" ||
       angular.element(event.target)[0].tagName is "TH" ||
       angular.element(event.target)[0].tagName is "A"
      if event.keyCode is keycode('Space') or
         event.keyCode is keycode('Up') or
         event.keyCode is keycode('Down') or
         event.keyCode is keycode('Page Up') or
         event.keyCode is keycode('Page Down') or
         event.keyCode is keycode('Right') or
         event.keyCode is keycode('Left') or
         event.keyCode is keycode('Home') or
         event.keyCode is keycode('End')
        event.preventDefault()

    # Wait for the table to be generated so the keydown events work
    setTimeout ->
      eventElement = angular.element(event.target)[0]
      numberOfColumns = 0
      hiddenColumns = []
      currentRowIndex = eventElement.parentNode.rowIndex
      actionColumnIndex =
        angular.element($element.find('tr')[2]).attr('data-column-start') - 1

      # Determine the number of visible columns
      angular.forEach $scope.thTable.delegate.headers, (header, index) ->
        if header.visible
          numberOfColumns++
        else
          hiddenColumns.push index

      unless currentColumnIndex >= 0 && currentColumnIndex < numberOfColumns
        currentColumnIndex = eventElement.cellIndex

      # Define helper functions

      # Select the rows' checkbox
      toggleCheckbox = ->
        currentRow = $element.find('tr')[currentRowIndex]
        firstCell = angular.element(currentRow).find('td')[0]
        checkboxElement = angular.element(firstCell).find('span')
        angular.element(checkboxElement).triggerHandler('click')

      # Focus on the cell above or below the current cell
      nextVerticalCell = (targetRow, cellElement) ->
        if angular.element(targetRow).hasClass('th-table-actions-row')
          targetRow.getElementsByClassName("has-actions")[0]
        else
          angular.element(targetRow).find(cellElement)[currentColumnIndex]

      # Focus on the first cell in the current column
      firstVerticalCell = ->
        angular.element($element.find('tr')[1]).find('td')[currentColumnIndex]

      # Focus on the last cell in the current column (excluding the action row)
      lastVerticalCell = ->
        lastRow = angular.element($element.find('tr')[$element.find('tr').length - 1])
        if angular.element(lastRow).hasClass('th-table-actions-row')
          lastRow = angular.element($element.find('tr')[$element.find('tr').length - 2])
        angular.element(lastRow).find('td')[currentColumnIndex]

      # Focus on the cell to the right or left of the current cell
      # (unless the current row is an action row)
      nextHorizontalCell = (direction) ->
        currentRow = $element.find('tr')[currentRowIndex]
        cellElement = if currentRowIndex is 0 then 'th' else 'td'

        unless angular.element(currentRow).hasClass('th-table-actions-row')
          i = eventElement.cellIndex
          while i <= (numberOfColumns - 1) and i >= 0
            nextIndex = if direction is 'right' then i + 1 else i - 1
            if hiddenColumns.indexOf(nextIndex) is -1
              currentColumnIndex =
                if direction is 'right'
                  eventElement.cellIndex + 1
                else
                  eventElement.cellIndex - 1
              return angular.element(currentRow).find(cellElement)[currentColumnIndex]
              break
            else
              if direction is 'right' then i++ else i--

      firstHorizontalCell = ->
        currentRow = $element.find('tr')[currentRowIndex]
        cellElement = if currentRowIndex is 0 then 'th' else 'td'
        unless angular.element(currentRow).hasClass('th-table-actions-row')
          angular.element(currentRow).find(cellElement)[0]

      lastHorizontalCell = ->
        currentRow = $element.find('tr')[currentRowIndex]
        cellElement = if currentRowIndex is 0 then 'th' else 'td'
        lastElementIndex = angular.element(currentRow).find(cellElement).length - 1
        unless angular.element(currentRow).hasClass('th-table-actions-row')
          nextCell = angular.element(currentRow).find(cellElement)[lastElementIndex]

      # Continue with event handling

      # Events for table cells
      if eventElement.tagName is "TD" ||
         eventElement.tagName is "TH"

        if event.keyCode is keycode('Up')
          cellElement = if currentRowIndex is 1 then 'th' else 'td'
          targetRow = $element.find('tr')[currentRowIndex - 1]
          nextCell = nextVerticalCell(targetRow, cellElement)

        if event.keyCode is keycode('Down')
          targetRow = $element.find('tr')[currentRowIndex + 1]
          nextCell = nextVerticalCell(targetRow, 'td')

        if event.keyCode is keycode('Page Up')
          nextCell = firstVerticalCell()

        if event.keyCode is keycode('Page Down')
          nextCell = lastVerticalCell()

        if event.keyCode is keycode('Right')
          nextCell = nextHorizontalCell('right')

        if event.keyCode is keycode('Left')
          if angular.element(eventElement).hasClass('th-table-pagination-link')
            previousPaginationControl = eventElement.previousElementSibling
            if previousPaginationControl
              # Skip the seperator
              if previousPaginationControl.text.replace(/^\s+|\s+$/g, '') == "…"
                previousPaginationControl = previousPaginationControl.previousElementSibling
              previousPaginationControl.focus()
          else
            nextCell = nextHorizontalCell('left')

        if event.keyCode is keycode('Home')
          nextCell = firstHorizontalCell()

        if event.keyCode is keycode('End')
          nextCell = lastHorizontalCell()

        if event.keyCode is keycode('Space')
          if eventElement.tagName is "TH"
            # Toggle a sorting event
            angular.element(event.target).triggerHandler('click')

          if eventElement.tagName is "TD"
            toggleCheckbox()

        if event.keyCode is keycode('Enter')
          # Focus on the first link if there is one
          firstLink = angular.element(eventElement).find('a')[0]
          firstLink.focus() if firstLink

      # Events for links and pagination
      if eventElement.tagName is "A"
        if event.keyCode is keycode('Right')
          nextAnchor = eventElement.nextElementSibling
          if nextAnchor
            # Skip the seperator
            if nextAnchor.text.replace(/^\s+|\s+$/g, '') == "…"
              nextAnchor = nextAnchor.nextElementSibling
            nextAnchor.focus()

        if event.keyCode is keycode('Left')
          previousAnchor = eventElement.previousElementSibling
          if previousAnchor
            # Skip the seperator
            if previousAnchor.text.replace(/^\s+|\s+$/g, '') == "…"
              previousAnchor = previousAnchor.previousElementSibling
            previousAnchor.focus()

        if event.keyCode is keycode('Enter')
          # Toggle a click event
          angular.element(eventElement).triggerHandler('click')

      if nextCell
        angular.element(eventElement).attr('aria-selected', 'false').attr('tabindex', '-1')
        nextCell.focus()
        angular.element(nextCell).attr('aria-selected', 'true').attr('tabindex', '0')
